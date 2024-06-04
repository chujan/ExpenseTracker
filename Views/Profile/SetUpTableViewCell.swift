//
//  SetUpTableViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 14/05/2024.
//

import UIKit

class SetUpTableViewCell: UITableViewCell {
    static let identifier = "SetUpTableViewCell"
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        
       
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemGray2.cgColor
        return view
    }()

    let NotificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(systemName: "bell")
        
        return imageView
    }()

    
   
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "Notifications"
        return label
        
    }()
    
  


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundViewContainer.layer.cornerRadius = 25
        backgroundViewContainer.layer.masksToBounds = true
       

        contentView.backgroundColor = .systemBackground
        NotificationImageView.tintColor = .white
       
       
      backgroundViewContainer.addSubview(NotificationImageView)
        contentView.addSubview(notificationLabel)
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
           
            NotificationImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
            NotificationImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
            NotificationImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.4),
            NotificationImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.4),
           
            notificationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            notificationLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
        ])
    }

}


class AppearanceTableViewCell: UITableViewCell {
    static let identifier = "AppearanceTableViewCell"

    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        
       
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemGray2.cgColor
        return view
    }()
    
    let apperanceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    
    
    let apperanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "Appearance"
        return label
        
    }()
   


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.backgroundColor = .systemBackground
        apperanceImageView.image = UIImage(systemName: "moonphase.first.quarter")
        backgroundViewContainer.layer.cornerRadius = 25
        backgroundViewContainer.layer.masksToBounds = true
        apperanceImageView.tintColor = .white
        contentView.addSubview(backgroundViewContainer)
       backgroundViewContainer.addSubview(apperanceImageView)
        contentView.addSubview(apperanceLabel)
        
        setUPContraints()
    }
    
    
    private func setUPContraints() {
        NSLayoutConstraint.activate([
            backgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 50),
            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
           
           apperanceImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
           apperanceImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
           apperanceImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.4),
           apperanceImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.4),
           
            apperanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            apperanceLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
            
          
            
            
            
        ])
        
    }

}


class AboutTableViewCell: UITableViewCell {
    static let identifier = "AboutTableViewCell"
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        
       
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemGray2.cgColor
        return view
    }()

   
    let aboutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
   
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "About"
        return label
        
    }()


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        backgroundViewContainer.layer.cornerRadius = 25
        backgroundViewContainer.layer.masksToBounds = true
        aboutImageView.tintColor = .white
        aboutImageView.image = UIImage(systemName: "questionmark")
        contentView.addSubview(backgroundViewContainer)
        contentView.backgroundColor = .systemBackground
       backgroundViewContainer.addSubview(aboutImageView)
        contentView.addSubview(aboutLabel)
        setUPContraints()
    }
    
    
    private func setUPContraints() {
        NSLayoutConstraint.activate([
            backgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 50),
            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
           
           aboutImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
          aboutImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
            aboutImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.4),
          aboutImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.4),
           
            aboutLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            aboutLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
            
          
            
            
            
        ])
        
    }

}
