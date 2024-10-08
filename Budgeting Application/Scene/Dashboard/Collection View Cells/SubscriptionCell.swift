//
//  SubscriptionCell.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 08.06.24.
//

import UIKit

final class SubscriptionCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "SubscriptionCollectionViewCell"
    
    private let customBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .cellBackgroundColor
        view.layer.masksToBounds = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Regular", size: 13)

        return label
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 11, weight: .regular)
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primaryTextColor
        label.textAlignment = .left
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 14)
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.textColor = .quaternaryTextColor
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 11)
        return label
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
        customBackgroundView.addSubview(emojiLabel)
        customBackgroundView.addSubview(categoryLabel)
        customBackgroundView.addSubview(costLabel)
        
        customBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            customBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            customBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            customBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: -2),
            
            emojiLabel.leadingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor, constant: 10),
            emojiLabel.centerYAnchor.constraint(equalTo: customBackgroundView.centerYAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 5),
            categoryLabel.centerYAnchor.constraint(equalTo: customBackgroundView.centerYAnchor),
            
            costLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 5),
            costLabel.centerYAnchor.constraint(equalTo: customBackgroundView.centerYAnchor, constant: 1),
        ])
    }
    
    // MARK: - Configure
    func configure(with subscription: SubscriptionOccurrence) {
        dateLabel.text = subscription.date.formattedWithoutYear()
        categoryLabel.text = subscription.subscriptionDescription
        costLabel.text = PlainNumberFormatterHelper.shared.format(amount: subscription.amount)

        if let category = SubscriptionCategory(rawValue: subscription.category) {
            emojiLabel.text = category.emoji
        } else {
            emojiLabel.text = "🔔"
        }
    }
}
