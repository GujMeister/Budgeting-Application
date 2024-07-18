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
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        let label = PaddedLabel()
        label.text = labelName
        label.backgroundColor = .backgroundColor
        label.font = UIFont(name: "ChesnaGrotesk-Bold", size: 12)
        label.textColor = .primaryTextColor
        label.textAlignment = .center

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: -7).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
    }
}
