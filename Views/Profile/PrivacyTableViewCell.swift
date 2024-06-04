//
//  PrivacyTableViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 14/05/2024.
//

import UIKit

class PrivacyTableViewCell: UITableViewCell {
    static let identifier = "PrivacyTableViewCell"
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        
       
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemGray2.cgColor
        return view
    }()

    let emailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(systemName: "envelope")
        
        return imageView
    }()

    
   
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "Change Email"
        return label
        
    }()
    
  


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundViewContainer.layer.cornerRadius = 25
        backgroundViewContainer.layer.masksToBounds = true
       

        contentView.backgroundColor = .systemBackground
       emailImageView.tintColor = .white
       
       
      backgroundViewContainer.addSubview(emailImageView)
        contentView.addSubview(emailLabel)
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
           
           emailImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
          emailImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
           emailImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.4),
          emailImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.4),
           
           emailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
           emailLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
        ])
    }

    

   

}


class PolicyTableViewCell: UITableViewCell {
    static let identifier = "PolicyTableViewCell"
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        
       
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemGray2.cgColor
        return view
    }()

    let emailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(systemName: "exclamationmark")
        
        return imageView
    }()

    
   
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "Privcy Policy"
        return label
        
    }()
    
  


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundViewContainer.layer.cornerRadius = 25
        backgroundViewContainer.layer.masksToBounds = true
       

        contentView.backgroundColor = .systemBackground
       emailImageView.tintColor = .white
       
       
      backgroundViewContainer.addSubview(emailImageView)
        contentView.addSubview(emailLabel)
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
           
           emailImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
          emailImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
           emailImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.2),
          emailImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.2),
           
           emailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
           emailLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
        ])
    }

    

   

}
