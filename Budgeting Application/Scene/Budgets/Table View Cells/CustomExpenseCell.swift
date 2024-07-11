//
//  CustomExpenseCell.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 04.07.24.
//

import UIKit

final class CustomExpenseCell: UITableViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "CustomExpenseCell"
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 14)
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Heebo-SemiBold", size: 14)
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
        addSubview(descriptionLabel)
        addSubview(amountLabel)
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 8),
            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Helper Functions
    func configure(with expense: BasicExpense) {
        emojiLabel.text = expense.category.emoji
        descriptionLabel.text = expense.expenseDescription
        amountLabel.text = PlainNumberFormatterHelper.shared.format(amount: expense.amount)
    }
}
