//
//  AccountInfoTableViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 13/05/2024.
//

import UIKit

class AccountInfoTableViewCell: UITableViewCell {
    static let identifier = "AccountInfoTableViewCell"
    var currentUser: User? {
                didSet {
                   
                }
            }
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        
       
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemGray2.cgColor
        return view
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
        
    }()

    let userLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.text = "username"
        return label
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(systemName: "at")
        
        return imageView
    }()
    
  
    
    public func commonInit() {
        if let currentUser = currentUser {
            usernameLabel.text = "\(currentUser.firstName) \(currentUser.lastName)"
            
        } else {
           usernameLabel.text = ""
            print("Name label ")
        }
       
    }
    
    func setupUserInfo() {
            if let userDict = UserDefaults.standard.dictionary(forKey: "currentUser") {
                currentUser = User(
                    uid: userDict["uid"] as! String,
                    firstName: userDict["firstName"] as! String,
                    lastName: userDict["lastName"] as! String,
                    email: userDict["email"] as! String
                )

                // Now, use `currentUser` as needed in your header view
                // For example, set user's name, profile image, etc.
              usernameLabel.text = "\(currentUser?.firstName ?? "") \(currentUser?.lastName ?? "")"
                // Set other UI elements with user information as needed
            }
        }
    
    func updateNameLabel(with user: User) {
                usernameLabel.text = "\(user.firstName) \(user.lastName)"
            }

    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundViewContainer.layer.cornerRadius = 25
        backgroundViewContainer.layer.masksToBounds = true
        contentView.addSubview(backgroundViewContainer)
      
        contentView.backgroundColor = .systemBackground
        
        backgroundViewContainer.addSubview(userImageView)
        userImageView.tintColor = .white
        commonInit()
        setupUserInfo()
        contentView.addSubview(usernameLabel)
        contentView.addSubview(userLabel)
       setupContraints()

        
    }
    
   
    
    private func setupContraints() {
      
        NSLayoutConstraint.activate([
            
            backgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 50),
            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
           
            userImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
           userImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
           userImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.4),
           userImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.4),
             
             userLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
             userLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
            
           
            usernameLabel .topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 20),
            usernameLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
            

            
           
            
            
            
        ])
        
      
        
       
    }
    
    

}


class EmailInfoTableViewCell: UITableViewCell {
    static let identifier = "EmailInfoTableViewCell"
    var currentUser: User? {
                didSet {
                   
                }
            }
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        
       
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemGray2.cgColor
        return view
    }()
    
   
    
    let emailAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
        
    }()
    
   
    
    let emaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(systemName: "envelope")
        
        return imageView
    }()
    
    let EmailPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.text = " Email Address"
        return label
    }()
        
    
   

    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundViewContainer.layer.cornerRadius = 25
        backgroundViewContainer.layer.masksToBounds = true
        contentView.addSubview(backgroundViewContainer)
        emaImageView.tintColor = .white
        commonInit()
        setupUserInfo()
        contentView.backgroundColor = .systemBackground
        
        backgroundViewContainer.addSubview(emaImageView)
    
        contentView.addSubview(EmailPlaceholderLabel)
        contentView.addSubview(emailAddressLabel)
 
        setupContraints()

        
    }
    
   
    
    private func setupContraints() {
      
        NSLayoutConstraint.activate([
            
            backgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 50),
            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
           
            emaImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
            emaImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
            emaImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.4),
            emaImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.4),
             
            EmailPlaceholderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
           EmailPlaceholderLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
            
           
           emailAddressLabel .topAnchor.constraint(equalTo: EmailPlaceholderLabel.bottomAnchor, constant: 20),
          emailAddressLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
            
            
        ])
        
      
       
    }
    
    public func commonInit() {
        if let currentUser = currentUser {
           emailAddressLabel.text = "\(currentUser.email) "
            
        } else {
           emailAddressLabel.text = ""
            print("Name label ")
        }
       
    }
    
    func setupUserInfo() {
            if let userDict = UserDefaults.standard.dictionary(forKey: "currentUser") {
                currentUser = User(
                    uid: userDict["uid"] as! String,
                    firstName: userDict["firstName"] as! String,
                    lastName: userDict["lastName"] as! String,
                    email: userDict["email"] as! String
                )

                // Now, use `currentUser` as needed in your header view
                // For example, set user's name, profile image, etc.
               emailAddressLabel.text = "\(currentUser?.email ?? "") "
                // Set other UI elements with user information as needed
            }
        }
    
    func updateNameLabel(with user: User) {
              emailAddressLabel.text = "\(user.email) "
            }
    
    

}











