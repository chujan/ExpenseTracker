//
//  IncomeAddedCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 28/02/2024.
//

import UIKit

class IncomeAddedCollectionViewCell: UICollectionViewCell {
    static let identifier = "IncomeAddedCollectionViewCell"
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
  
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        imageView.tintColor = .white
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
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dashLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .green
        label.text = "+"
        label.font = .systemFont(ofSize: 25, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundViewContainer)
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(dashLabel)
        addSubview(amountLabel)
        addSubview(dateLabel)
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
            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
            
            iconImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.7), // Adjust the multiplier
            iconImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.7),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
            dashLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dashLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            amountLabel.leadingAnchor.constraint(equalTo: dashLabel.trailingAnchor),
            
            
            
        ])
    }
    
    func configure(with recent: UserIncomeItem) {
        nameLabel.text = recent.itemName
        timeLabel.text = recent.time
        
        // Add Naira sign in front of the amount label
        let nairaAmount = "₦" + recent.income
        amountLabel.text = nairaAmount
        
        // Set the icon image based on the category
        let (iconImage, backgroundColor) = iconImageAndColor(for: recent.category)
        iconImageView.image = iconImage
        backgroundViewContainer.backgroundColor = backgroundColor
    }
}

extension IncomeAddedCollectionViewCell {
    func iconImageAndColor(for category: String) -> (UIImage?, UIColor) {
        switch category {
        case "Salary":
            return (UIImage(systemName: "arrow.triangle.2.circlepath"), UIColor.systemBlue)
        case "Gift":
            return (UIImage(systemName: "cart"), UIColor.systemGreen)
        case "Pension":
            return (UIImage(systemName: "fork.knife"), UIColor.systemOrange)
        case "Alimony":
            return (UIImage(systemName: "bag"), UIColor.systemPurple)
        // Add more cases as needed for other categories
        default:
            return (UIImage(systemName: "questionmark"), UIColor.systemGray)
        }
    }
}





    

