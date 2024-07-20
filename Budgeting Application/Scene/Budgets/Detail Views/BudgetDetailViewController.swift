//
//  BudgetDetailViewController.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

import UIKit

protocol BudgetDetailViewControllerDelegate: AnyObject {
    func didUpdateFavoriteStatus(for budget: BasicExpenseBudget)
}

final class BudgetDetailViewController: UIViewController {
    // MARK: - Properties
    var budget: BasicExpenseBudget?
    weak var delegate: BudgetDetailViewControllerDelegate?
    private var viewModel = BudgetsViewModel()
    
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
        label.numberOfLines = 2
        return label
    }()
    
    private let remainingAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let spentAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Regular", size: 20)
        label.textAlignment = .left
        return label
    }()
    
    private let maxAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Regular", size: 20)
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
        bindViewModel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        spentAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        maxAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(categoryLabel)
        view.addSubview(progressView)
        view.addSubview(spentAmountLabel)
        view.addSubview(maxAmountLabel)
        view.addSubview(remainingAmountLabel)
        view.addSubview(favoriteButton)
        view.addSubview(topView)
        view.addSubview(emojiLabel)
        
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
            
            spentAmountLabel.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            spentAmountLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            
            maxAmountLabel.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
            maxAmountLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            
            remainingAmountLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            remainingAmountLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor)
        ])
    }
    
    // MARK: - Bind ViewModel
    func bindViewModel() {
        BudgetsViewModel.shared.onFavoritedBudgetsUpdated = { [weak self] in
            self?.updateFavoriteButtonTitle()
        }
    }
    
    // MARK: - Helper Functions
    private func configureView() {
        guard let budget = budget else { return }
        categoryLabel.text = budget.category.rawValue
        emojiLabel.text = budget.category.emoji
        
        if budget.remainingAmount < 0 {
            remainingAmountLabel.text = "Overdue:\n\(PlainNumberFormatterHelper.shared.format(amount: abs(budget.remainingAmount)))"
        } else {
            remainingAmountLabel.text = "Remaining:\n\(PlainNumberFormatterHelper.shared.format(amount: abs(budget.remainingAmount)))"
        }
        
        spentAmountLabel.text = "Spent: \(PlainNumberFormatterHelper.shared.format(amount: abs(budget.spentAmount)))"
        maxAmountLabel.text = "Max: \(PlainNumberFormatterHelper.shared.format(amount: abs(budget.totalAmount)))"
        progressView.setProgress(spent: budget.spentAmount, total: budget.totalAmount, animated: true)
        updateFavoriteButtonTitle()
    }
    
    private func favoriteButtonTapped() {
        guard let budget = budget else { return }
        if BudgetsViewModel.shared.isBudgetFavorited(budget) {
            BudgetsViewModel.shared.removeBudgetFromFavorites(budget)
        } else {
            BudgetsViewModel.shared.addBudgetToFavorites(budget)
        }
        updateFavoriteButtonTitle()
        delegate?.didUpdateFavoriteStatus(for: budget)
    }
    
    private func updateFavoriteButtonTitle() {
        guard let budget = budget else { return }
        
        if BudgetsViewModel.shared.favoritedBudgets.contains(where: { $0.category == budget.category }) {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = .red
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .red
        }
    }
}
