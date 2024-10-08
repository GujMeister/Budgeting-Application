//
//  BudgetView.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 14.06.24.
//

import UIKit

class BudgetView: UIView {
    // MARK: - Properties
    private let circleLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    var shouldExecuteTapAction: Bool?
    
    private let emojiView: UILabel = {
        let label = UILabel()
        label.text = "🖥️"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .primaryTextColor
        label.font = UIFont(name: "ChesnaGrotesk-Bold", size: 12)
        label.text = "$100"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .quaternaryTextColor
        label.font = UIFont(name: "ChesnaGrotesk-Regular", size: 10)
        label.text = "over"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var budget: BasicExpenseBudget? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    init(budget: BasicExpenseBudget, shouldExecuteTapAction: Bool) {
        self.budget = budget
        self.shouldExecuteTapAction = shouldExecuteTapAction
        super.init(frame: .zero)
        setupView()
    }
    
    // MARK: - Setup UI
    private func setupView() {
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
        
        self.addSubview(emojiView)
        self.addSubview(amountLabel)
        self.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            emojiView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emojiView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            amountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            amountLabel.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 25),
            
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: -3)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(budgetTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = 30
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.budgetViewBezierColor.cgColor
        circleLayer.lineWidth = 5
        circleLayer.lineCap = .round
        
        let remainingAmount = budget?.remainingAmount
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = remainingAmount ?? 1 < 0 ? UIColor(hex: "#b30000").cgColor : UIColor(hex: "#008000").cgColor
        progressLayer.lineWidth = 5
        progressLayer.lineCap = .round
    }
    
    @objc private func budgetTapped() {
        guard let budget = budget else { return }
        if shouldExecuteTapAction ?? false {
            NotificationCenter.default.post(name: NSNotification.Name("BudgetTapped"), object: budget)
        }
    }
    
    // MARK: - Update View
    private func updateView() {
        guard let budget = budget else { return }
        
        let remainingPercentage = min(CGFloat(budget.remainingPercentage), 1.0)
        
        progressLayer.strokeEnd = 0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = remainingPercentage
        animation.duration = 1
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: "progressAnim")
        
        let remainingAmount = budget.remainingAmount
        
        amountLabel.text = PlainNumberFormatterHelper.shared.format(amount: abs(remainingAmount))
        
        statusLabel.text = remainingAmount < 0 ? "over" : "under"
        
        emojiView.text = budget.category.emoji
    }
}
