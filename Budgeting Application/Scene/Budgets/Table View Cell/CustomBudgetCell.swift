//
//  CustomBudgetCell.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

import UIKit

class CustomBudgetCell: UITableViewCell {
    
    static let reuseIdentifier = "CustomBudgetCell"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let spentAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
        addSubview(nameLabel)
        addSubview(spentAmountLabel)
        addSubview(totalAmountLabel)
        addSubview(progressBar)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        spentAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            spentAmountLabel.trailingAnchor.constraint(equalTo: progressBar.leadingAnchor, constant: -8),
            spentAmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            progressBar.leadingAnchor.constraint(equalTo: spentAmountLabel.trailingAnchor, constant: 6),
            progressBar.trailingAnchor.constraint(equalTo: totalAmountLabel.leadingAnchor, constant: -6),
            progressBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            progressBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            totalAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            totalAmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with budget: BasicExpenseBudget) {
        nameLabel.text = budget.category.rawValue
        spentAmountLabel.text = NumberFormatterHelper.shared.format(amount: budget.spentAmount)
        totalAmountLabel.text = NumberFormatterHelper.shared.format(amount: budget.totalAmount)
        
        let progress = Float(budget.spentAmount / budget.totalAmount)
        progressBar.progress = progress
        progressBar.progressTintColor = progress > 1.0 ? .red : .green
    }
}
