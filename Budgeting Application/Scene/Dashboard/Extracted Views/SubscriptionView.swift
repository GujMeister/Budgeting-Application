import UIKit

class SubscriptionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "SubscriptionCollectionViewCell"
    
    private let customBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
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
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            dateLabel.bottomAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: -2),
            
            emojiLabel.leadingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor, constant: 8),
            emojiLabel.centerYAnchor.constraint(equalTo: customBackgroundView.centerYAnchor),
            emojiLabel.topAnchor.constraint(greaterThanOrEqualTo: customBackgroundView.topAnchor, constant: 5),
            
            categoryLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 5),
            categoryLabel.centerYAnchor.constraint(equalTo: customBackgroundView.centerYAnchor),
            
            costLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 5),
            costLabel.centerYAnchor.constraint(equalTo: customBackgroundView.centerYAnchor),
            costLabel.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor, constant: -8),
            costLabel.bottomAnchor.constraint(greaterThanOrEqualTo: customBackgroundView.bottomAnchor, constant: 5),
        ])
    }
    
    // MARK: - Configure
    func configure(with subscription: SubscriptionExpenseModel) {
        dateLabel.text = DateFormatter.localizedString(from: subscription.startDate ?? Date(), dateStyle: .medium, timeStyle: .none)
        categoryLabel.text = subscription.subscriptionDescription
        costLabel.text = String(format: "$%.2f", subscription.amount)
        
        if let category = SubscriptionCategory(rawValue: subscription.category ?? "") {
            emojiLabel.text = category.emoji
        } else {
            emojiLabel.text = "🔔"
        }
    }
}

#Preview {
    SubscriptionCollectionViewCell()
}

