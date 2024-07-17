//
//  NavigationRectangle.swift
//  PersonalFinance
//
//  Created by Luka Gujejiani on 28.06.24.
//

import UIKit
import SwiftUI

class NavigationRectangle: UIView {
    // MARK: - Properties
    private let height: CGFloat
    private let rectangleColor: UIColor
    private let totalBudgetedMoney: NSAttributedString
    private let descriptionLabelText: String
    
    lazy var totalBudgetedNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "Heebo-SemiBold", size: 40)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Regular", size: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers
    init(height: CGFloat, color: UIColor, totalBudgetedMoney: NSAttributedString, descriptionLabelText: String) {
        self.height = height
        self.rectangleColor = color
        self.totalBudgetedMoney = totalBudgetedMoney
        self.descriptionLabelText = descriptionLabelText
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupView() {
        backgroundColor = rectangleColor
        totalBudgetedNumberLabel.attributedText = totalBudgetedMoney
        descriptionLabel.text = descriptionLabelText
        
        addSubview(totalBudgetedNumberLabel)
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            totalBudgetedNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            totalBudgetedNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: totalBudgetedNumberLabel.bottomAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    // MARK: - Bottom corner radius
    override func layoutSubviews() {
        super.layoutSubviews()
        roundBottomCorners(radius: 30)
    }
    
    private func roundBottomCorners(radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
