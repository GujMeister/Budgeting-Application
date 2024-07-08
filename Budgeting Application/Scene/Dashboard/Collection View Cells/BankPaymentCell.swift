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
        view.backgroundColor = .customLightBlue
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.text = "1 Apr"
        label.font = .systemFont(ofSize: 16, weight: .regular)
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
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var emojiBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 15
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
        contentView.addSubview(dateLabel)
        contentView.addSubview(customBackgroundView)
        
        customBackgroundView.addSubview(emojiBackgroundView)
        customBackgroundView.addSubview(emojiLabel)
        customBackgroundView.addSubview(categoryLabel)
        customBackgroundView.addSubview(costLabel)
        
        customBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            dateLabel.bottomAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: -3),
            
            customBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            customBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            customBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            categoryLabel.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 25),
            categoryLabel.trailingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: -10),
            
            emojiLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            emojiLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            emojiLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            emojiLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            
            emojiBackgroundView.heightAnchor.constraint(equalTo: emojiLabel.heightAnchor, multiplier: 1.5),
            emojiBackgroundView.widthAnchor.constraint(equalTo: emojiLabel.widthAnchor, multiplier: 1.5),
            emojiBackgroundView.centerXAnchor.constraint(equalTo: emojiLabel.centerXAnchor),
            emojiBackgroundView.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor),
            
            costLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            costLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
    
    // MARK: - Configure
    func configure(with payment: PaymentExpenseModel, textColor: UIColor) {
        dateLabel.text = DateFormatter.localizedString(from: payment.startDate ?? Date(), dateStyle: .medium, timeStyle: .none)
        categoryLabel.text = payment.paymentDescription
        costLabel.text = PlainNumberFormatterHelper.shared.format(amount: payment.amount)
        
        dateLabel.textColor = textColor
        categoryLabel.textColor = textColor
        costLabel.textColor = textColor
        
        
        if let category = PaymentsCategory(rawValue: payment.category ?? "") {
            emojiLabel.text = category.emoji
            emojiBackgroundView.backgroundColor = category.color
        } else {
            emojiLabel.text = "🔔"
            emojiBackgroundView.backgroundColor = UIColor.customLightBlue
        }
    }
}
