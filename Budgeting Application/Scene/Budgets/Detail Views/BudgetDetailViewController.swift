//
//  BudgetDetailViewController.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

import UIKit

protocol BudgetDetailViewControllerDelegate: AnyObject {
    func didUpdateFavoriteStatus(for budget: BasicExpenseBudget)
    func isBudgetFavoritedDelegate(_ budget: BasicExpenseBudget) -> Bool
}

final class BudgetDetailViewController: UIViewController {
    // MARK: - Properties
    internal var budget: BasicExpenseBudget?
    weak var delegate: BudgetDetailViewControllerDelegate?
    
    private var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 3
        return view
    }()
    
    private var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Bold", size: 28)
        label.textColor = .primaryTextColor
        label.numberOfLines = 2
        return label
    }()
    
    private let remainingAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Bold", size: 22)
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let spentAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 16)
        label.textColor = .primaryTextColor
        label.textAlignment = .left
        return label
    }()
    
    private let maxAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 16)
        label.textColor = .primaryTextColor
        label.textAlignment = .right
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.addAction(UIAction(handler: { _ in
            self.favoriteButtonTapped()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var progressView: CircularProgressView = {
        let view = CircularProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureView()
        updateFavoriteButtonTitle()
    }
    
    deinit {
        print("Deiniting BudgetDetailViewController")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        let views = [categoryLabel,progressView, spentAmountLabel, maxAmountLabel, remainingAmountLabel, favoriteButton, topView, emojiLabel]
        
        views.forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            topView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topView.heightAnchor.constraint(equalToConstant: 5),
            topView.widthAnchor.constraint(equalToConstant: 60),
            
            categoryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            favoriteButton.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor, constant: 0),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emojiLabel.centerYAnchor.constraint(equalTo: favoriteButton.centerYAnchor),
            emojiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 40),
            progressView.widthAnchor.constraint(equalToConstant: 250),
            progressView.heightAnchor.constraint(equalToConstant: 250),
            
            spentAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            spentAmountLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            
            maxAmountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            maxAmountLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            
            remainingAmountLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            remainingAmountLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor)
        ])
    }
    
    // MARK: - Helper Functions
    private func configureView() {
        guard let budget = budget else { return }
        categoryLabel.text = budget.category.rawValue.translated()
        emojiLabel.text = budget.category.emoji
        
        if budget.remainingAmount < 0 {
            remainingAmountLabel.text = "\("budget_detail_overdue".translated()):\n\(PlainNumberFormatterHelper.shared.format(amount: abs(budget.remainingAmount)))"
        } else {
            remainingAmountLabel.text = "\("budget_detail_remaining".translated()):\n\(PlainNumberFormatterHelper.shared.format(amount: abs(budget.remainingAmount)))"
        }
        
        spentAmountLabel.text = "\("budget_detail_spent".translated()): \(PlainNumberFormatterHelper.shared.format(amount: abs(budget.spentAmount)))"
        maxAmountLabel.text = "\("budget_detail_max".translated()): \(PlainNumberFormatterHelper.shared.format(amount: abs(budget.totalAmount)))"
        progressView.setProgress(spent: budget.spentAmount, total: budget.totalAmount, animated: true)
    }
    
    // MARK: - Delegate Methods
    private func favoriteButtonTapped() {
        guard let budget = budget else { return }
        delegate?.didUpdateFavoriteStatus(for: budget)
        updateFavoriteButtonTitle()
    }
    
    private func updateFavoriteButtonTitle() {
        guard let budget = budget else { return }
        let isFavorited = delegate?.isBudgetFavoritedDelegate(budget) ?? false
        let image = isFavorited ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = .red
    }
}
