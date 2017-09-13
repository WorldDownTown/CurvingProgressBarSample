//
//  CurvingProgressView.swift
//  CurvingProgressBarSample
//
//  Created by Keisuke Shoji on 2017/09/12.
//  Copyright © 2017年 Keisuke Shoji. All rights reserved.
//

import UIKit

final class CurvingProgressView: UIView {

    var percentage: Int = 100
    var animationCurve: AnimationCurve = .linear
    private let lineX: CGFloat = 0.0
    private let lineY: CGFloat = 64.0
    private let baseLineLayer: CAShapeLayer = .init()
    private let lineLayer: CAShapeLayer = .init()
    private var progressTimer: ProgressTimer!

    @IBOutlet private weak var percentageLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let nib = UINib(nibName: "\(type(of: self))", bundle: nil)
        guard let contentView = nib.instantiate(withOwner: self).first as? UIView else { return }
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        baseLineLayer.strokeColor = UIColor.lightGray.cgColor
        baseLineLayer.lineWidth = 6.0
        baseLineLayer.strokeStart = 0.0
        baseLineLayer.strokeEnd = 1.0
        baseLineLayer.lineCap = kCALineCapRound
        layer.addSublayer(baseLineLayer)

        lineLayer.strokeColor = UIColor.clear.cgColor
        lineLayer.lineWidth = 6.0
        lineLayer.strokeStart = 0.0
        lineLayer.strokeEnd = 0.0
        lineLayer.lineCap = kCALineCapRound
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.startAnimation()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupBaseLineLayerPath(width: frame.width)
    }

    private func updateProgress(progress: CGFloat) {
        let progressInt: Int = Int(progress * CGFloat(percentage))
        percentageLabel?.text = "\(progressInt)"
        lineLayer.strokeEnd = progress

        let color: UIColor = {
            switch progressInt {
            case 0...33:   return .red
            case 34...66:  return .orange
            case 67...100: return .green
            default:       return .red
            }
        }()
        percentageLabel?.textColor = color
        lineLayer.strokeColor = color.cgColor
    }

    private func setupBaseLineLayerPath(width: CGFloat) {
        guard baseLineLayer.path == nil else { return }

        let path: CGMutablePath = .init()
        let start: CGPoint = .init(x: lineX, y: lineY)
        let end: CGPoint = .init(x: (width - lineX), y: lineY)
        path.move(to: start)
        path.addLine(to: end)
        baseLineLayer.path = path
    }

    private func startAnimation() {
        guard percentage > 0, lineLayer.path == nil else { return }

        let path: CGMutablePath = .init()
        let start: CGPoint = .init(x: lineX, y: lineY)
        let x: CGFloat = (frame.width - lineX * 2.0) * CGFloat(percentage) * 0.01 + lineX
        let end: CGPoint = .init(x: x, y: lineY)
        path.move(to: start)
        path.addLine(to: end)
        lineLayer.path = path
        layer.addSublayer(lineLayer)

        progressTimer = ProgressTimer(duration: 2.0, animationCurve: animationCurve)
        progressTimer.progressBlock = { [weak self] (progress: CGFloat) in
            self?.updateProgress(progress: progress)
        }
        progressTimer.startTimer()
    }
}
