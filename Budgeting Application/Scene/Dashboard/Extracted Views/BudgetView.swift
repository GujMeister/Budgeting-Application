import UIKit

class BudgetView: UIView {
    // MARK: - Properties
    private let circleLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    private let emojiView: UILabel = {
        let label = UILabel()
        label.text = "🖥️"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var budget: BasicExpenseBudget? {
        didSet {
            updateView()
        }
    }
    
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
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
        
        self.addSubview(emojiView)
        self.addSubview(amountLabel)
        self.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            emojiView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emojiView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            amountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            amountLabel.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 23),
            
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor)
        ])
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = 30
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.systemGray5.cgColor
        circleLayer.lineWidth = 5
        circleLayer.lineCap = .round
        
        let remainingAmount = budget?.remainingAmount
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = remainingAmount ?? 1 < 0 ? UIColor.red.cgColor : UIColor.green.cgColor
        progressLayer.lineWidth = 5
        progressLayer.lineCap = .round
    }
    
    // MARK: - Update View
    private func updateView() {
        guard let budget = budget else { return }
        
        let remainingPercentage = min(CGFloat(budget.remainingPercentage), 1.0)
        
        progressLayer.strokeEnd = 0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = remainingPercentage
        animation.duration = 1.5 // Adjust the duration as needed
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: "progressAnim")
        
        let remainingAmount = budget.remainingAmount
        amountLabel.text = String(format: "$%.2f", abs(remainingAmount))
        statusLabel.text = remainingAmount < 0 ? "over" : "under"
        
        emojiView.text = budget.category.emoji
    }
}

#Preview {
    BudgetView()
}
