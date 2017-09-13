//
//  ProgressTimer.swift
//  CurvingProgressBarSample
//
//  Created by Keisuke Shoji on 2017/09/12.
//  Copyright © 2017年 Keisuke Shoji. All rights reserved.
//

import QuartzCore

enum AnimationCurve {
    case linear, ease, easeIn, easeOut, easeInOut, original(CGPoint, CGPoint)

    var p1: CGPoint {
        switch self {
        case .linear:             return .zero
        case .ease:               return CGPoint(x: 0.25, y: 0.1)
        case .easeIn:             return CGPoint(x: 0.42, y: 0.0)
        case .easeOut:            return .zero
        case .easeInOut:          return CGPoint(x: 0.42, y: 0.0)
        case .original(let p, _): return p
        }
    }

    var p2: CGPoint {
        switch self {
        case .linear:             return CGPoint(x: 1.0, y: 1.0)
        case .ease:               return CGPoint(x: 0.25, y: 1.0)
        case .easeIn:             return CGPoint(x: 1.0, y: 1.0)
        case .easeOut:            return CGPoint(x: 0.58, y: 1.0)
        case .easeInOut:          return CGPoint(x: 0.58, y: 1.0)
        case .original(_, let p): return p
        }
    }
}

final class ProgressTimer {

    private var displayLink: CADisplayLink!
    private var startTimeInterval: TimeInterval = 0.0
    private let duration: TimeInterval
    private let unitBezier: UnitBezier
    var progressBlock: ((CGFloat) -> Void)?

    init(duration: TimeInterval = 1.0, animationCurve: AnimationCurve) {
        self.duration = duration
        unitBezier = UnitBezier(p1: animationCurve.p1, p2: animationCurve.p2)

        displayLink = CADisplayLink(target: self, selector: #selector(updateTimer))
        displayLink.preferredFramesPerSecond = 60
        displayLink.isPaused = true
        displayLink.add(to: .current, forMode: .commonModes)
    }

    func startTimer() {
        startTimeInterval = Date.timeIntervalSinceReferenceDate
        displayLink.isPaused = false
    }

    @objc private func updateTimer() {
        let elapsed: TimeInterval = Date.timeIntervalSinceReferenceDate - startTimeInterval
        let progress: CGFloat = (elapsed > duration) ? 1.0 : CGFloat(elapsed / duration)

        // cubic bezier
        let y: CGFloat = unitBezier.solve(t: progress)
        progressBlock?(y)

        if progress == 1.0 {
            displayLink.isPaused = true
        }
    }
}
