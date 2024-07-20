//
//  CircularProgressView.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 20.07.24.
//

import UIKit

class CircularProgressView: UIView {
    private var spent: Double = 0
    private var total: Double = 0
    private let shapeLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(shapeLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayers()
    }

    private func configureLayers() {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = min(bounds.width, bounds.height) / 2 - 10
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi

        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 10
        backgroundLayer.lineCap = .round

        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
    }

    func setProgress(spent: Double, total: Double, animated: Bool) {
        self.spent = spent
        self.total = total

        let progress = min(spent / total, 1.0)
        let strokeColor = progressColor(for: progress)
        shapeLayer.strokeColor = strokeColor.cgColor

        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.toValue = progress
            animation.duration = 1.0
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            shapeLayer.add(animation, forKey: "progressAnim")
        } else {
            shapeLayer.strokeEnd = CGFloat(progress)
        }
    }

    private func progressColor(for progress: Double) -> UIColor {
        switch progress {
        case 0..<0.5:
            return .green
        case 0.5..<0.75:
            return .yellow
        case 0.75...1:
            return .red
        default:
            return .red
        }
    }
}
