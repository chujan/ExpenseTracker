//
//  AddedCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 16/02/2024.
//

import UIKit

protocol AddedCollectionViewCellDelegate: AnyObject {
    func deleteButtonTapped(_ cell: AddedCollectionViewCell)
}


class AddedCollectionViewCell: UICollectionViewCell {
    static let identifier = "AddedCollectionViewCell"
    weak var delegate: AddedCollectionViewCellDelegate?
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
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
        label.textColor = .red
        label.text = "-"
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
        addSubview(deleteButton)
        addSubview(dateLabel)
        setupContrsint()
        
        contentView.backgroundColor = .secondarySystemBackground
        
        //contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
        
       // contentView.layer.borderColor = UIColor.white.cgColor
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func deleteButtonTapped() {
        // Handle delete action
        delegate?.deleteButtonTapped(self)
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
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            deleteButton.leadingAnchor.constraint(equalTo: amountLabel.trailingAnchor, constant: 20),
            
            
        ])
    }
    
    func configure(with recent: UserExpenseItem) {
        nameLabel.text = recent.itemName
        print("Configuring cell with itemName: \(recent.itemName)")
        timeLabel.text = recent.time
        
        // Add Naira sign in front of the amount label
        let nairaAmount = "₦" + recent.amount
        amountLabel.text = nairaAmount
        
        // Set the icon image based on the category
        let (iconImage, backgroundColor) = iconImageAndColor(for: recent.category)
        iconImageView.image = iconImage
        backgroundViewContainer.backgroundColor = backgroundColor
    }
}

extension AddedCollectionViewCell {
    func iconImageAndColor(for category: String) -> (UIImage?, UIColor) {
        switch category {
        case "Recurring":
            return (UIImage(systemName: "arrow.triangle.2.circlepath"), UIColor.systemBlue)
        case "Grocery":
            return (UIImage(systemName: "cart"), UIColor.systemGreen)
        case "Food":
            return (UIImage(systemName: "fork.knife"), UIColor.systemOrange)
        case "Shopping":
            return (UIImage(systemName: "bag"), UIColor.systemPurple)
        case "Gadgets":
            return (UIImage(systemName: "oven"), UIColor.cyan)
        case "Fuel":
            return (UIImage(systemName: "fuelpump"), UIColor.systemMint)
        case "Online":
            return (UIImage(systemName: "globe"), UIColor.systemYellow)
        case "Net Banking":
            return (UIImage(systemName: "building.columns"), UIColor.systemBrown)
        case "Kids":
            return (UIImage(systemName: "figure.and.child.holdinghands"), UIColor.systemIndigo)
        case "Travels":
            return (UIImage(systemName: "airplane"), UIColor.systemRed)
        case "Cinema":
            return (UIImage(systemName: "film"), UIColor.systemPink)
        case "Sport":
            return (UIImage(systemName: "figure.run"), UIColor.link)
       
       
       
       
            
              
       
       
        default:
            // Check if nameLabel.text is empty or nil
            if let itemName = nameLabel.text, !itemName.isEmpty {
                // If itemName is not empty, use a default image and color
                return (UIImage(systemName: "questionmark"), UIColor.systemGray)
            } else {
                // If itemName is empty or nil, return a placeholder image and color
                return (UIImage(systemName: "questionmark.circle"), UIColor.lightGray)
            }


        }
    }
}




