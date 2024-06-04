//
//  ExpenseCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 06/04/2024.
//

import UIKit

class ExpenseCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExpenseCollectionViewCell"
    private let backgroundViewContainer: UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           
           view.layer.cornerRadius = 20
           view.layer.borderWidth = 2.0
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
    
  
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
          
            contentView.addSubview(backgroundViewContainer)
            addSubview(iconImageView)
            addSubview(nameLabel)
           
            
            NSLayoutConstraint.activate([
                
                backgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                            backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                            backgroundViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 40),
                            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 40),
                
               iconImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
                            iconImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
                           iconImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.7), // Adjust the multiplier
                            iconImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.7), // Adjust the multiplier




                           nameLabel.topAnchor.constraint(equalTo: backgroundViewContainer.bottomAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                //nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
                
                //nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
                
                
                        
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    func configure(with category: ExpenseCategory) {
       // print("Configuring cell with category: \(category.name)")
        nameLabel.text = category.name
        iconImageView.image = UIImage(systemName: category.icon ?? "")
        
        
       
        
        
    }


    
    
}
