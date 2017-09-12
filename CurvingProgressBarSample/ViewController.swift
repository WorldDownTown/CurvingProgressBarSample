//
//  ViewController.swift
//  CurvingProgressBarSample
//
//  Created by Keisuke Shoji on 2017/09/12.
//  Copyright © 2017年 Keisuke Shoji. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private var progressViews: [CurvingProgressView]!

    override func viewDidLoad() {
        super.viewDidLoad()

        let animationCurves: [AnimationCurve] = [
            .linear,
            .ease,
            .easeIn,
            .easeOut,
            .easeInOut,
            .original(CGPoint(x: 0.51, y: 0.0), CGPoint(x: 0.61, y: 1.0)),
        ]
        for (view, curve) in zip(progressViews, animationCurves) {
            view.animationCurve = curve
        }
    }
}
