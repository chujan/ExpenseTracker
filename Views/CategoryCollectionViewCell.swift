//
//  CategoryCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 10/02/2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    var userAddedItems: [UserExpenseItem] = []
    private let backgroundViewContainer: UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           
           view.layer.cornerRadius = 25
           view.layer.borderWidth = 1.0
           view.layer.borderColor = UIColor.systemGray4.cgColor
           return view
       }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.systemIndigo.withAlphaComponent(0.9)
       

        return imageView
    }()

        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.textColor = .systemGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let noTransactionLabel: UILabel = {
           let label = UILabel()
           label.text = "No Transactions yet, Add Transactions to get started"
          // label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .thin)
        
         
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
  
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
          
            contentView.addSubview(backgroundViewContainer)
            addSubview(iconImageView)
            addSubview(nameLabel)
            addSubview(noTransactionLabel)
           
            
            NSLayoutConstraint.activate([
                
                backgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                            backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                            backgroundViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
                            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 50),
                
               iconImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
                            iconImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
                           iconImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.65), // Adjust the multiplier
                            iconImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.65), // Adjust the multiplier




                           nameLabel.topAnchor.constraint(equalTo: backgroundViewContainer.bottomAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                noTransactionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: +170),
                noTransactionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
                noTransactionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                        
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    func configure(with category: ExpenseCategory?, hasCategories: Bool) {
        if let category = category {
            nameLabel.text = category.name
            iconImageView.image = UIImage(systemName: category.icon ?? "")
            backgroundViewContainer.isHidden = false
            noTransactionLabel.isHidden = true
        } else {
            backgroundViewContainer.isHidden = true
            noTransactionLabel.isHidden = hasCategories
        }
    }

}
