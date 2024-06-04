//
//  IncomeCategoriesCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 05/03/2024.
//

import UIKit

class IncomeCategoriesCollectionViewCell: UICollectionViewCell {
    static let identifier = "IncomeCategoriesCollectionViewCell"
    private let backgroundViewContainer: UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           
           view.layer.cornerRadius = 30
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
                
                // Setting fixed width and height for backgroundViewContainer
                backgroundViewContainer.widthAnchor.constraint(equalToConstant: 60),
                backgroundViewContainer.heightAnchor.constraint(equalToConstant: 60),
                
                // Centering iconImageView within backgroundViewContainer
                iconImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.7),
                iconImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.7),
               
               



                nameLabel.topAnchor.constraint(equalTo: backgroundViewContainer.bottomAnchor, constant: 2),
                nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                
                //nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
                
                //nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
                
                
                        
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    func configure(with category: IncomeCategory) {
       // print("Configuring cell with category: \(category.name)")
        nameLabel.text = category.name
        iconImageView.image = UIImage(systemName: category.icon ?? "")
        
        
       
        
        
    }


    
}
