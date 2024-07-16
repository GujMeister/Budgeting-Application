import UIKit

final class SubscriptionCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "SubscriptionCollectionViewCell"
    
    private let customBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.customBlue.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 5
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
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#71797E")
        label.textAlignment = .left
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 14)
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont(name: "Heebo-SemiBold", size: 10)
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
            costLabel.centerYAnchor.constraint(equalTo: customBackgroundView.centerYAnchor),
        ])
    }
    
    // MARK: - Configure
    func configure(with subscription: SubscriptionOccurrence/*, textColor: UIColor*/) {
        dateLabel.text = DateFormatter.localizedString(from: subscription.date, dateStyle: .medium, timeStyle: .none)
        categoryLabel.text = subscription.subscriptionDescription
        costLabel.text = PlainNumberFormatterHelper.shared.format(amount: subscription.amount)
        
        //        categoryLabel.textColor = textColor
        //        costLabel.textColor = textColor
        
        if let category = SubscriptionCategory(rawValue: subscription.category) {
            emojiLabel.text = category.emoji
        } else {
            emojiLabel.text = "🔔"
        }
    }
}

#Preview {
    SubscriptionCollectionViewCell()
}

