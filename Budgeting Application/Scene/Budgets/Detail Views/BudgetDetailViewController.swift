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
    
    // MARK: - Bind View Model
    private func bindViewModel() {
        BudgetsViewModel.shared.showAlertForMaxFavorites = { [weak self] in
            self?.showMaxFavoritesMessage()
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
        let viewModel = BudgetsViewModel()
        
        if viewModel.favoritedBudgets.contains(where: { $0.category == budget.category }) {
            viewModel.removeBudgetFromFavorites(budget)
        } else {
            viewModel.addBudgetToFavorites(budget)
        }
        
        if BudgetsViewModel.shared.favoritedBudgets.count >= 5 {
            BudgetsViewModel.shared.showAlertForMaxFavorites?()
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
    
    private func showMaxFavoritesMessage() {
        let alert = UIAlertController(title: "Alert", message: "You have reached the maximum number of favorited budgets", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)


        UIView.animate(withDuration: 0.25, animations: {
            self.favoriteButton.transform = CGAffineTransform(rotationAngle: .pi / 8)
        }) { _ in
            UIView.animate(withDuration: 0.25, animations: {
                self.favoriteButton.transform = CGAffineTransform(rotationAngle: -.pi / 8)
            }) { _ in
                UIView.animate(withDuration: 0.25, animations: {
                    self.favoriteButton.transform = CGAffineTransform.identity
                })
            }
        }
    }
}

// MARK: - Circular Progress View
class CircularProgressView: UIView {
    private var spent: Double = 0
    private var total: Double = 0
    private let shapeLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(shapeLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayers()
    }

    private func configureLayers() {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = min(bounds.width, bounds.height) / 2 - 10
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi

        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 10

        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0
    }

    func setProgress(spent: Double, total: Double, animated: Bool) {
        self.spent = spent
        self.total = total

        let progress = min(spent / total, 1.0)
        let strokeColor = progressColor(for: progress)
        shapeLayer.strokeColor = strokeColor.cgColor

        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.toValue = progress
            animation.duration = 1.0
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            shapeLayer.add(animation, forKey: "progressAnim")
        } else {
            shapeLayer.strokeEnd = CGFloat(progress)
        }
    }

    private func progressColor(for progress: Double) -> UIColor {
        switch progress {
        case 0..<0.5:
            return .green
        case 0.5..<0.75:
            return .yellow
        case 0.75...1:
            return .red
        default:
            return .red
        }
    }
}
