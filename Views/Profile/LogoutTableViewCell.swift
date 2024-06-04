//
//  LogoutTableViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 12/05/2024.
//

import UIKit

class LogoutTableViewCell: UITableViewCell {
    static let identifier = " LogoutTableViewCell"
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        
       
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemGray2.cgColor
        return view
    }()

    let personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        
        return imageView
    }()

    
   
    
    let personLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "Logout"
        return label
        
    }()
    
  


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundViewContainer.layer.cornerRadius = 25
        backgroundViewContainer.layer.masksToBounds = true
       

        contentView.backgroundColor = .systemBackground
     personImageView.tintColor = .white
       
       
      backgroundViewContainer.addSubview(personImageView)
        contentView.addSubview(personLabel)
        contentView.addSubview(backgroundViewContainer)
       
        setUPContraints()
    }
    
   
    
    private func setUPContraints() {
        NSLayoutConstraint.activate([
            backgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 50),
            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
           
           personImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
           personImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
           personImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.4),
            personImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.4),
           
            personLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            personLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
        ])
        
       
    }

}
