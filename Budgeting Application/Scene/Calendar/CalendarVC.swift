//
//  CalendarViewController.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 11.07.24.
//

import UIKit

class CalendarViewController: UIViewController {
    private var viewModel = CalendarViewModel()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .customBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let calendarLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Bold", size: 26)
        label.text = "Calendar"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var calendar: UICalendarView = {
        let calendar = UICalendarView()
        calendar.backgroundColor = .customBackground
        calendar.calendar = Calendar(identifier: .gregorian)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selection
        calendar.delegate = self
        return calendar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var eventsIndicatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var noDataBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .customLightBlue
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No data for selected Date"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModelCallbacks()
        viewModel.loadEvents()
    }
    
    private func setupUI() {
            self.navigationController?.isNavigationBarHidden = true
            view.backgroundColor = .customBackground
            view.addSubview(scrollView)
            
            scrollView.addSubview(contentView)
            contentView.addSubview(topView)
            contentView.addSubview(calendarLabel)
            contentView.addSubview(calendar)
            contentView.addSubview(tableView)
            contentView.addSubview(noDataBackgroundView)
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
                
                calendar.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
                calendar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                calendar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                
                tableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
                tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                tableView.heightAnchor.constraint(equalToConstant: 350),
                tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
                
                noDataBackgroundView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
                noDataBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                noDataBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                noDataBackgroundView.heightAnchor.constraint(equalToConstant: 100),
                
                noDataLabel.centerYAnchor.constraint(equalTo: noDataBackgroundView.centerYAnchor),
                noDataLabel.centerXAnchor.constraint(equalTo: noDataBackgroundView.centerXAnchor),
            ])
        }
    
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
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        viewModel.events(for: sender.date)
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
        let image = UIImage(systemName: "3.circle")?.withTintColor(.customBlue, renderingMode: .alwaysOriginal)
        return .image(image)
    }

    private func createDoubleDotDecorationImage() -> UICalendarView.Decoration {
        let image = UIImage(systemName: "2.circle")?.withTintColor(.customBlue, renderingMode: .alwaysOriginal)
        return .image(image)
    }

    private func createSingleDotDecorationImage() -> UICalendarView.Decoration {
        let image = UIImage(systemName: "1.circle")?.withTintColor(.customBlue, renderingMode: .alwaysOriginal)
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
