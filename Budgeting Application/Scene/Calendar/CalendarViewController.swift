//
//  CalendarViewController.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 11.07.24.
//

import UIKit

final class CalendarViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: CalendarViewModel
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        UIScrollView.appearance().bounces = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .infoViewColor
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let calendarLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Bold", size: 26)
        label.text = ""
        return label
    }()
    
    private lazy var calendarInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "ChesnaGrotesk-Bold", size: 14)
        
        let config = UIImage.SymbolConfiguration(pointSize: 9)
        let chevron = UIImage(systemName: "info.circle.fill", withConfiguration: config)
        button.setImage(chevron, for: .normal)
        button.tintColor = .infoViewColor
        button.semanticContentAttribute = .forceRightToLeft
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapCalendarInfoButton()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var calendar: UICalendarView = {
        let calendar = UICalendarView()
        calendar.backgroundColor = .backgroundColor
        calendar.calendar = Calendar(identifier: .gregorian)
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selection
        calendar.delegate = self
        return calendar
    }()
    
    private lazy var tableViewInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "ChesnaGrotesk-Bold", size: 14)
        
        let config = UIImage.SymbolConfiguration(pointSize: 9)
        let chevron = UIImage(systemName: "info.circle.fill", withConfiguration: config)
        button.setImage(chevron, for: .normal)
        button.tintColor = .infoViewColor
        button.semanticContentAttribute = .forceRightToLeft
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapInformationTableButton()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.allowsSelection = false
        tableView.backgroundColor = .backgroundColor
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var noDataBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .NavigationRectangleColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModelCallbacks()
        viewModel.loadEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadEvents()
        updateLocalizedTexts()
    }

    // MARK: - Setup UI
    private func setupUI() {
        updateLocalizedTexts()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .backgroundColor
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let subviews = [topView, calendarLabel, calendarInfoButton, calendar, tableViewInfoButton, tableView, noDataBackgroundView]
        
        subviews.forEach { 
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        noDataBackgroundView.addSubview(noDataLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 8),
            
            calendarLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 20),
            calendarLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            
            calendarInfoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            calendarInfoButton.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
            
            calendar.topAnchor.constraint(equalTo: calendarInfoButton.bottomAnchor, constant: 10),
            calendar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            calendar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            tableViewInfoButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
            tableViewInfoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: tableViewInfoButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 350),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150),
            
            noDataBackgroundView.topAnchor.constraint(equalTo: tableViewInfoButton.bottomAnchor, constant: 10),
            noDataBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            noDataBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            noDataBackgroundView.heightAnchor.constraint(equalToConstant: 200),
            
            noDataLabel.centerYAnchor.constraint(equalTo: noDataBackgroundView.centerYAnchor),
            noDataLabel.centerXAnchor.constraint(equalTo: noDataBackgroundView.centerXAnchor),
        ])
    }
    
    // MARK: - Binding ViewModel
    private func setupViewModelCallbacks() {
        viewModel.onEventsUpdated = { [weak self] in
            DispatchQueue.main.async {
                let hasData = !(self?.viewModel.selectedDateEvents.isEmpty ?? true)
                self?.tableView.isHidden = !hasData
                self?.noDataBackgroundView.isHidden = hasData
                self?.noDataLabel.isHidden = hasData
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    func didTapCalendarInfoButton() {
        presentAlert(from: self, title: "calendar_info_button".translated(), message: "calendar_alert_message".translated())
    }
    
    func didTapInformationTableButton() {
        presentAlert(from: self, title: "calendar_table_info_button".translated(), message: "table_info_alert_message".translated())
    }
    
    // MARK: - Helper Functions
    @objc private func dateChanged(_ sender: UIDatePicker) {
        viewModel.events(for: sender.date)
    }
    
    private func updateLocalizedTexts() {
        calendarInfoButton.setTitle("calendar_info_button".translated(), for: .normal)
        tableViewInfoButton.setTitle("calendar_table_info_button".translated(), for: .normal)
        noDataLabel.text = "calendar_no_data".translated()
        tableView.reloadData()
        self.view.layoutIfNeeded()
    }
}

// MARK: - Calendar Delegate
extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents, let date = Calendar.current.date(from: dateComponents) else { return }
        viewModel.events(for: date)
    }
}

extension CalendarViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        guard let date = Calendar.current.date(from: dateComponents) else {
            return nil
        }
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        let hasExpenses = viewModel.expensesByDate[startOfDay] != nil
        let hasSubscriptions = viewModel.subscriptionsByDate[startOfDay] != nil
        let hasPayments = viewModel.paymentsByDate[startOfDay] != nil
        
        if hasExpenses && hasSubscriptions && hasPayments {
            return createTripleDotDecorationImage()
        } else if (hasExpenses && hasSubscriptions) || (hasExpenses && hasPayments) || (hasSubscriptions && hasPayments) {
            return createDoubleDotDecorationImage()
        } else if hasExpenses || hasSubscriptions || hasPayments {
            return createSingleDotDecorationImage()
        } else {
            return nil
        }
    }
    
    private func createTripleDotDecorationImage() -> UICalendarView.Decoration {
        let image = UIImage(systemName: "3.circle")?.withTintColor(.NavigationRectangleColor, renderingMode: .alwaysOriginal)
        return .image(image)
    }
    
    private func createDoubleDotDecorationImage() -> UICalendarView.Decoration {
        let image = UIImage(systemName: "2.circle")?.withTintColor(.NavigationRectangleColor, renderingMode: .alwaysOriginal)
        return .image(image)
    }
    
    private func createSingleDotDecorationImage() -> UICalendarView.Decoration {
        let image = UIImage(systemName: "1.circle")?.withTintColor(.NavigationRectangleColor, renderingMode: .alwaysOriginal)
        return .image(image)
    }
}

// MARK: - Table View
extension CalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = viewModel.sections[section]
        return viewModel.selectedDateEvents.filter {
            switch sectionTitle {
            case "Expenses": return $0 is BasicExpense
            case "Subscriptions": return $0 is SubscriptionOccurrence
            case "Payments": return $0 is PaymentOccurrence
            default: return false
            }
        }.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as! CalendarTableViewCell
        let sectionTitle = viewModel.sections[indexPath.section]
        let events = viewModel.selectedDateEvents
        let event: Any
        
        switch sectionTitle {
        case "Expenses": event = events.filter { $0 is BasicExpense }[indexPath.row]
        case "Subscriptions": event = events.filter { $0 is SubscriptionOccurrence }[indexPath.row]
        case "Payments": event = events.filter { $0 is PaymentOccurrence }[indexPath.row]
        default: return cell
        }
        
        if let expense = event as? BasicExpense {
            cell.configure(emoji: expense.category.rawValue, categoryName: expense.expenseDescription, amount: expense.amount)
            cell.backgroundColor = .clear
        } else if let subscription = event as? SubscriptionOccurrence {
            cell.configure(emoji: subscription.category, categoryName: subscription.subscriptionDescription, amount: subscription.amount)
            cell.backgroundColor = .clear
        } else if let payment = event as? PaymentOccurrence {
            cell.configure(emoji: payment.category, categoryName: payment.subscriptionDescription, amount: payment.amount)
            cell.backgroundColor = .clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.gray
        header.textLabel?.font = UIFont(name: "ChesnaGrotesk-Medium", size: 12)
    }
}

extension CalendarViewController: UITableViewDelegate {}
