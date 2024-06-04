//
//  MessageCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 10/05/2024.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    static let identifier = "MessageCollectionViewCell"
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
    
    
    
    let iconCategoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.systemIndigo.withAlphaComponent(0.9)
        
        
        return imageView
        
    }()
    
    
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    let dashLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .red
        label.text = "-"
        label.font = .systemFont(ofSize: 25, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundViewContainer)
        addSubview(iconCategoryImageView)
        addSubview(nameLabel)
        
        addSubview(dashLabel)
        addSubview(amountLabel)
        
        
        setupContrsint()
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.shadowColor = UIColor.link.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
        
        contentView.layer.borderColor = UIColor.white.cgColor
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupContrsint() {
        NSLayoutConstraint.activate([
            backgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 40),
            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 40),
            
            iconCategoryImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
            iconCategoryImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
            iconCategoryImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.7), // Adjust the multiplier
            iconCategoryImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.7), // Adjust the multiplier
            
            
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
            
            
            dashLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dashLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            amountLabel.leadingAnchor.constraint(equalTo: dashLabel.trailingAnchor),
            
            
            
            
        ])
    }
    
    func configure(categoryTotalAmount: Double, categoryName: String) {
        let totalAmountString = "₦" + String(format: "%.2f", categoryTotalAmount)
        amountLabel.text = totalAmountString

        nameLabel.text = categoryName

       
       // amountLabel.text = "green\(categoryTotalAmount)"
    }
    
}
