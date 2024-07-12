//
//  CalendarTableViewCell.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 12.07.24.
//

import UIKit

final class CalendarTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "CalendarTableViewCell"
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 14)
        return label
    }()
    
    let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont(name: "ChesnaGrotesk-Regular", size: 12)
        return label
    }()

    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Bold", size: 14)
        return label
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        addSubview(emojiLabel)
        addSubview(categoryNameLabel)
        addSubview(amountLabel)
        
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            categoryNameLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 10),
            categoryNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    // MARK: - Helper function
    func configure(emoji: String, categoryName: String, amount: Double) {
        emojiLabel.text = emoji
        categoryNameLabel.text = categoryName
        
        amountLabel.attributedText = NumberFormatterHelper.shared.format(amount: amount, baseFont: UIFont(name: "Heebo-SemiBold", size: 8) ?? UIFont(), sizeDifference: 1.1)
    }
}
