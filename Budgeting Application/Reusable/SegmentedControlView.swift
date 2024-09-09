//
//  SegmentedControlView.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 04.07.24.
//

import UIKit
import SwiftUI

class CustomSegmentedControlView: UIView {
    // MARK: - Properties
    private var color: UIColor
    private var controlItems: [String]
    private var segmentChangeCallback: ((Int) -> Void)?
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: controlItems)
        control.backgroundColor = color
        control.selectedSegmentTintColor = UIColor.white
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: "2B2A4C")], for: .normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        control.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        control.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = color
        return view
    }()
    
    // MARK: - Initialization
    init(color: UIColor, controlItems: [String], defaultIndex: Int, segmentChangeCallback: ((Int) -> Void)?) {
        self.color = color
        self.controlItems = controlItems
        self.segmentChangeCallback = segmentChangeCallback
        super.init(frame: .zero)
        setupView()
        setSelectedIndex(defaultIndex)
    }
    
    required init?(coder: NSCoder) {
        self.color = .blue
        self.controlItems = ["Hello", "Xmello"]
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup UI
    private func setupView() {
        addSubview(segmentedControl)
        addSubview(topView)
        setupConstraints()
        applyCornerRadius()
    }
    
    private func setupConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 60),
            
            topView.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: 20),
            topView.heightAnchor.constraint(equalToConstant: 60),
            topView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor),
        ])
    }
    
    func updateControlItems(_ newControlItems: [String]) {
        controlItems = newControlItems
        segmentedControl.removeAllSegments()
        
        for (index, item) in newControlItems.enumerated() {
            segmentedControl.insertSegment(withTitle: item, at: index, animated: false)
        }
        // Reset to the previous selected index if necessary
        segmentedControl.selectedSegmentIndex = 0 // Or your default
    }

    
    private func applyCornerRadius() {
        let bounds = CGRect(
            x: 0,
            y: 5,
            width: segmentedControl.bounds.width,
            height: segmentedControl.bounds.height - 20
        )
        
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 100, height: 0))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        segmentedControl.layer.mask = mask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyCornerRadius()
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        segmentChangeCallback?(sender.selectedSegmentIndex)
    }
    
    func setSelectedIndex(_ index: Int) {
        segmentedControl.selectedSegmentIndex = index
    }
}
