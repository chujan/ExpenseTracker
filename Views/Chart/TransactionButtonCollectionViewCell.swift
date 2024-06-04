//
//  TransactionButtonCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 21/04/2024.
//

import UIKit

class TransactionButtonCollectionViewCell: UICollectionViewCell {
    static let identifier = "TransactionButtonCollectionViewCell"
    private var collectionView: UICollectionView!
    private var buttonTappedAction: ((String) -> Void)?

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 8
        
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    

    func configure(with buttons: [UIButton], buttonTappedAction: ((String) -> Void)?) {
        // Clear existing buttons
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Add new buttons to your cell's contentView
        for button in buttons {
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }

        // Save the buttonTappedAction to call it later
        self.buttonTappedAction = buttonTappedAction
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        // Get the title of the tapped button
        guard let title = sender.titleLabel?.text else {
            return
        }

        // Call the stored buttonTappedAction with the selected category
        buttonTappedAction?(title)
    }
}



import UIKit

class SearchButtonCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchButtonCollectionViewCell"
    private var collectionView: UICollectionView!
    private var buttonTappedAction: ((String) -> Void)?

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 8
        
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    

    func configure(with buttons: [UIButton], buttonTappedAction: ((String) -> Void)?) {
        // Clear existing buttons
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Add new buttons to your cell's contentView
        for button in buttons {
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }

        // Save the buttonTappedAction to call it later
        self.buttonTappedAction = buttonTappedAction
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        // Get the title of the tapped button
        guard let title = sender.titleLabel?.text else {
            return
        }

        // Call the stored buttonTappedAction with the selected category
        buttonTappedAction?(title)
    }
}


