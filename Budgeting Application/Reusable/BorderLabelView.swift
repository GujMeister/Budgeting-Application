//
//  BorderLabelView.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 06.07.24.
//

import UIKit

class PaddedLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width + 20, height: super.intrinsicContentSize.height)
    }
}

class BorderLabelView: UIView {
    private let label = PaddedLabel()

    convenience init(labelName: String) {
        self.init()

        let contentView = UIView()
        contentView.backgroundColor = .backgroundColor
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.NavigationRectangleColor.cgColor
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true

        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor)
        ])

        label.text = labelName.translated()
        label.backgroundColor = .backgroundColor
        label.font = UIFont(name: "ChesnaGrotesk-Bold", size: 12)
        label.textColor = .primaryTextColor
        label.textAlignment = .center

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: -7),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 15)
        ])
    }

    func updateLabelText(_ newText: String) {
        label.text = newText.translated()
    }
}
