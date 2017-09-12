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
    private let animationCurve: AnimationCurve
    var progressBlock: ((CGFloat) -> Void)?

    init(duration: TimeInterval = 1.0, animationCurve: AnimationCurve) {
        self.duration = duration
        self.animationCurve = animationCurve

        displayLink = CADisplayLink(target: self, selector: #selector(updateTimer))
        displayLink.preferredFramesPerSecond = 60   // 60FPS
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
        let t: CGFloat = progress
        // cubic bezier
        let y0: CGFloat = 0.0
        let y1: CGFloat = animationCurve.p1.y
        let y2: CGFloat = animationCurve.p2.y
        let y3: CGFloat = 1.0
        let computedProgress: CGFloat
            = (1.0 - t) * (1.0 - t) * (1.0 - t) * y0
                + 3.0 * (1.0 - t) * (1.0 - t) * t * y1
                + 3.0 * (1.0 - t) * t * t * y2
                + t * t * t * y3
        progressBlock?(computedProgress)

        if computedProgress == 1.0 {
            displayLink.isPaused = true
        }
    }
}