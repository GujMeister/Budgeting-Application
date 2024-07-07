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

class BudgetDetailViewController: UIViewController {
    // MARK: - Properties
    var budget: BasicExpenseBudget?
    weak var delegate: BudgetDetailViewControllerDelegate?

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let remainingAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()

    private let spentAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Favorites", for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureView()
    }

    private func setupUI() {
        view.backgroundColor = .white

        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        spentAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(categoryLabel)
        view.addSubview(remainingAmountLabel)
        view.addSubview(spentAmountLabel)
        view.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            remainingAmountLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
            remainingAmountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            spentAmountLabel.topAnchor.constraint(equalTo: remainingAmountLabel.bottomAnchor, constant: 20),
            spentAmountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            favoriteButton.topAnchor.constraint(equalTo: spentAmountLabel.bottomAnchor, constant: 20),
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configureView() {
        guard let budget = budget else { return }
        categoryLabel.text = budget.category.rawValue
        remainingAmountLabel.text = "Remaining: \(budget.remainingAmount)"
        spentAmountLabel.text = "Spent: \(budget.spentAmount)"
        updateFavoriteButtonTitle()
    }

//    @objc private func favoriteButtonTapped() {
//        guard let budget = budget else { return }
//        let viewModel = BudgetsViewModel()
//        if let index = viewModel.favoritedBudgets.firstIndex(where: { $0.category == budget.category }) {
//            viewModel.favoritedBudgets.remove(at: index)
//            print("Removing from faves")
//        } else {
//            viewModel.favoritedBudgets.append(budget)
//            print("Adding to faves")
//        }
//        updateFavoriteButtonTitle()
//        delegate?.didUpdateFavoriteStatus(for: budget)
//    }
    
    @objc private func favoriteButtonTapped() {
        guard let budget = budget else { return }
        let viewModel = BudgetsViewModel()
        if viewModel.favoritedBudgets.contains(where: { $0.category == budget.category }) {
            viewModel.removeBudgetFromFavorites(budget)
        } else {
            viewModel.addBudgetToFavorites(budget)
        }
        
        updateFavoriteButtonTitle()
        delegate?.didUpdateFavoriteStatus(for: budget)
    }

    private func updateFavoriteButtonTitle() {
        guard let budget = budget else { return }
        let viewModel = BudgetsViewModel()
        if viewModel.favoritedBudgets.contains(where: { $0.category == budget.category }) {
            favoriteButton.setTitle("Remove from Favorites", for: .normal)
        } else {
            favoriteButton.setTitle("Add to Favorites", for: .normal)
        }
    }
}
