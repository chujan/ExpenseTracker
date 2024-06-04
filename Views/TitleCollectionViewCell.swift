//
//  TitleCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 26/02/2024.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"

    private var buttonTappedAction: (() -> Void)?


    private let stackViewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "History"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Your Button Title", for: .normal)
        button.tintColor = .systemGray2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stackViewTitleLabel)
        contentView.addSubview(button)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        NSLayoutConstraint.activate([
            stackViewTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackViewTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackViewTitleLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
            stackViewTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    }

    public func configure(buttonTitle: String, buttonTappedAction: (() -> Void)?) {
        button.setTitle(buttonTitle, for: .normal)
        self.buttonTappedAction = buttonTappedAction
    }


    @objc private func buttonTapped(_ sender: UIButton) {
        buttonTappedAction?()
    }


}
