//
//  CustomBudgetCell.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

import UIKit

class CustomBudgetCell: UITableViewCell {
    
    static let reuseIdentifier = "CustomBudgetCell"
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    var spentAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    let spentAmountTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Already spent:"
        label.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .lightGray
        return progressView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(emojiLabel)
        addSubview(categoryNameLabel)
        addSubview(spentAmountLabel)
        addSubview(totalAmountLabel)
        addSubview(progressBar)
        addSubview(spentAmountTextLabel)
        
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        spentAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        spentAmountTextLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            categoryNameLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 3),
            categoryNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            totalAmountLabel.trailingAnchor.constraint(equalTo: spentAmountLabel.trailingAnchor),
            totalAmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -8),
            
            spentAmountLabel.trailingAnchor.constraint(equalTo: progressBar.leadingAnchor, constant: -8),
            spentAmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 8),
            
            spentAmountTextLabel.trailingAnchor.constraint(equalTo: spentAmountLabel.leadingAnchor, constant: -4),
            spentAmountTextLabel.centerYAnchor.constraint(equalTo: spentAmountLabel.centerYAnchor),
            
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            progressBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            progressBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 5),
        ])
    }
    
    func configure(with budget: BasicExpenseBudget) {
        emojiLabel.text = budget.category.emoji
        categoryNameLabel.text = budget.category.rawValue
        
        spentAmountLabel.attributedText = NumberFormatterHelper.shared.format(amount: budget.spentAmount, baseFont: UIFont(name: "Heebo-SemiBold", size: 8) ?? UIFont(), sizeDifference: 1.1)
        totalAmountLabel.attributedText = NumberFormatterHelper.shared.format(amount: budget.totalAmount, baseFont: UIFont(name: "Heebo-SemiBold", size: 8) ?? UIFont(), sizeDifference: 1.1)

        let progress = Float(budget.spentAmount / budget.totalAmount)
        progressBar.progress = progress
        progressBar.progressTintColor = progress > 1.0 ? .red : .green
    }
}
