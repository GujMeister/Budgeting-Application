//
//  BankPaymentCollectionViewCell.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 08.07.24.
//

import UIKit

final class BankPaymentCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "BankPaymentCollectionViewCell"
    
    private let customBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .cellBackgroundColor
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .quaternaryTextColor
        label.textAlignment = .left
        label.text = "1 Apr"
        label.font = UIFont(name: "ChesnaGrotesk-Regular", size: 12)
        return label
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .regular)
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primaryTextColor
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont(name: "ChesnaGrotesk-Bold", size: 18)
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primaryTextColor
        label.textAlignment = .left
        label.font = UIFont(name: "ChesnaGrotesk-Bold", size: 14)
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
        
        customBackgroundView.addSubview(emojiLabel)
        customBackgroundView.addSubview(dateLabel)
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
            
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            categoryLabel.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 10),
            
            emojiLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            emojiLabel.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor, constant: -10),
            emojiLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            emojiLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),

            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            dateLabel.bottomAnchor.constraint(equalTo: costLabel.topAnchor, constant: -2),
            
            costLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            costLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        
        customBackgroundView.clipsToBounds = true
    }
    
    // MARK: - Configure
    func configure(with payment: PaymentOccurrence) {
        dateLabel.text = payment.date.formattedDate()
        categoryLabel.text = payment.subscriptionDescription
        
        costLabel.attributedText = NumberFormatterHelper.shared.format(amount: payment.amount, baseFont: UIFont(name: "Heebo-SemiBold", size: 17) ?? UIFont(), sizeDifference: 0.8)
        
        if let category = PaymentsCategory(rawValue: payment.category) {
            emojiLabel.text = category.emoji
            lineColorView.backgroundColor = category.color
        } else {
            emojiLabel.text = "🔔"
            lineColorView.backgroundColor = UIColor.red
        }
    }
}
