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
            .easeInOut,
        ]
        for (view, curve) in zip(progressViews, animationCurves) {
            view.animationCurve = curve
        }
    }
}
