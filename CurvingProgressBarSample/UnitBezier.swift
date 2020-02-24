import CoreGraphics

/// Solver for cubic bezier curve with implicit control points at (0, 0) and (1, 1)
struct UnitBezier {
    private let a: CGPoint
    private let b: CGPoint
    private let c: CGPoint
    private let epsilon: CGFloat = 0.000001

    init(p1: CGPoint, p2: CGPoint) {
        // pre-calculate the polynomial coefficients
        // First and last control points are implied to be (0, 0) and (1, 1)
        c = CGPoint(x: 3 * p1.x,
                    y: 3 * p1.y)
        b = CGPoint(x: 3 * (p2.x - p1.x) - c.x,
                    y: 3 * (p2.y - p1.y) - c.y)
        a = CGPoint(x: 1 - c.x - b.x,
                    y: 1 - c.y - b.y)
    }

    private func sampleCurveX(t: CGFloat) -> CGFloat {
        ((a.x * t + b.x) * t + c.x) * t
    }

    private func solveCurveXByNewtonMethod(t: CGFloat) -> CGFloat? {
        var t2: CGFloat = t
        var x2: CGFloat = 0

        // First try a few iterations of Newton's method -- normally very fast.
        for _ in 0 ..< 8 {
            x2 = sampleCurveX(t: t2) - t
            if abs(x2) < epsilon {
                return t2
            }

            let derivativeT2: CGFloat = (3 * a.x * t2 + 2 * b.x) * t2 + c.x
            if abs(derivativeT2) >= epsilon {
                break
            }
            t2 -= x2 / derivativeT2
        }
        return nil
    }

    private func solveCurveXByBiSection(t arg: CGFloat) -> CGFloat {
        let t: CGFloat = min(max(arg, 0), 1)
        var t0: CGFloat = 0
        var t1: CGFloat = 1
        var t2: CGFloat = t
        var x2: CGFloat = 0

        while t0 < t1 {
            x2 = sampleCurveX(t: t2)
            if abs(x2 - t) < epsilon {
                break
            } else if t > x2 {
                t0 = t2
            } else {
                t1 = t2
            }
            t2 = (t1 - t0) / 2 + t0
        }

        return t2
    }

    private func solveCurveX(t: CGFloat) -> CGFloat {
        solveCurveXByNewtonMethod(t: t) ?? solveCurveXByBiSection(t: t)
    }

    private func sampleCurveY(t: CGFloat) -> CGFloat {
        ((a.y * t + b.y) * t + c.y) * t
    }

    // Find new T as a function of Y along curve X
    func solve(t: CGFloat) -> CGFloat {
        sampleCurveY(t: solveCurveX(t: t))
    }
}
