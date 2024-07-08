//
//  BankPaymentCell.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 08.07.24.
//

import UIKit
import SwiftUI
import CoreData

class BankPaymentCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "BankPaymentCollectionViewCell"
    
    private let customBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = .systemGray5
        view.layer.masksToBounds = false  // Ensure this is false to allow shadows
        view.layer.shadowColor = UIColor.customBlue.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.textAlignment = .left
        label.text = "1 Apr"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .regular)
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()

    private let lineColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup UI
    private func setupView() {
        contentView.addSubview(customBackgroundView)
        
        customBackgroundView.addSubview(dateLabel)
//        customBackgroundView.addSubview(emojiBackgroundView)
        customBackgroundView.addSubview(emojiLabel)
        customBackgroundView.addSubview(categoryLabel)
        customBackgroundView.addSubview(costLabel)
        customBackgroundView.addSubview(lineColorView)
        
        customBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            customBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            customBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            lineColorView.topAnchor.constraint(equalTo: customBackgroundView.topAnchor),
            lineColorView.bottomAnchor.constraint(equalTo: customBackgroundView.bottomAnchor),
            lineColorView.leadingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor),
            lineColorView.widthAnchor.constraint(equalTo: customBackgroundView.widthAnchor, multiplier: 0.05),
            
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            categoryLabel.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 25),
            categoryLabel.trailingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 10),
            
            emojiLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            emojiLabel.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor, constant: -20),
            emojiLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            emojiLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),

            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            dateLabel.bottomAnchor.constraint(equalTo: costLabel.topAnchor, constant: -8),
            
            costLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            costLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
        
        customBackgroundView.clipsToBounds = true
    }
    
    // MARK: - Configure
    func configure(with payment: PaymentExpenseModel, textColor: UIColor) {
        dateLabel.text = DateFormatter.localizedString(from: payment.startDate ?? Date(), dateStyle: .medium, timeStyle: .none)
        categoryLabel.text = payment.paymentDescription
        costLabel.attributedText = NumberFormatterHelper.shared.format(amount: payment.amount, baseFont: UIFont(name: "Heebo-SemiBold", size: 50) ?? UIFont(), sizeDifference: 0.2)
        
        categoryLabel.textColor = textColor
        costLabel.textColor = textColor
        
        if let category = PaymentsCategory(rawValue: payment.category ?? "") {
            emojiLabel.text = category.emoji
            lineColorView.backgroundColor = category.color
        } else {
            emojiLabel.text = "🔔"
            lineColorView.backgroundColor = UIColor.red
        }
    }
}
