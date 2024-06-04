//
//  BalanceTableViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 15/05/2024.
//

import UIKit



    class BalanceTableViewCell: UITableViewCell {
        static let identifier = "BalanceTableViewCell"
        
        private let emailbackgroundViewContainer: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .systemGray
            
           
            view.layer.borderWidth = 2.0
            view.layer.borderColor = UIColor.systemGray2.cgColor
            return view
        }()
        
        private let smsBackgroundViewContainer: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = .systemGray
                view.layer.borderWidth = 2.0
                view.layer.borderColor = UIColor.systemGray2.cgColor
                return view
            }()
        
        let smsImageView: UIImageView = {
               let imageView = UIImageView()
               imageView.translatesAutoresizingMaskIntoConstraints = false
               imageView.contentMode = .scaleAspectFill
               imageView.image = UIImage(systemName: "message")
               return imageView
           }()
        let smsNotify: UILabel = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = .systemFont(ofSize: 15, weight: .medium)
                label.text = "SMS"
                return label
            }()

        let emailImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            
            imageView.image = UIImage(systemName: "envelope")
            
            return imageView
        }()
        
        let emailType: UILabel = {
            let label =  UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 12, weight: .medium)
            label.text = "Notifications about what your recent transactions is"
            return label
            
        }()
        
        let emailNotify: UILabel = {
            let label =  UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 15, weight: .medium)
            label.text = "Email"
            return label
            
        }()
        
        let emailNotifySwitch: UISwitch = {
               let toggleSwitch = UISwitch()
               toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
               toggleSwitch.isOn = false // Set default state
               return toggleSwitch
           }()
        
        let smsNotifySwitch: UISwitch = {
                let toggleSwitch = UISwitch()
                toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
                toggleSwitch.isOn = false // Set default state
                return toggleSwitch
            }()

       

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            contentView.addSubview(emailbackgroundViewContainer)
            contentView.addSubview(smsBackgroundViewContainer)
            emailbackgroundViewContainer.addSubview(emailImageView)
            smsBackgroundViewContainer.addSubview(smsImageView)
            contentView.addSubview(smsNotify)
            contentView.addSubview(emailType)
            contentView.addSubview(emailNotify)
            contentView.addSubview(emailNotifySwitch)
            contentView.addSubview(smsNotifySwitch)
            setUpContraints()
            emailbackgroundViewContainer.layer.cornerRadius = 25
            emailbackgroundViewContainer.layer.masksToBounds = true
            smsBackgroundViewContainer.layer.cornerRadius = 25
            smsBackgroundViewContainer.layer.masksToBounds = true
            smsImageView.tintColor = .white
                    

            contentView.backgroundColor = .systemBackground
           emailImageView.tintColor = .white
            emailNotifySwitch.isOn = UserDefaults.standard.bool(forKey: "notificationsEnabled")
            smsNotifySwitch.isOn = UserDefaults.standard.bool(forKey: "notificationsEnabled")
            emailNotifySwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            smsNotifySwitch.addTarget(self, action: #selector(smsSwitchValueChanged(_:)), for: .valueChanged)

          
        }
        
        @objc private func switchValueChanged(_ sender: UISwitch) {
            // Handle the switch value change
            if sender.isOn {
                print("Notifications Enabled")
            } else {
                print("Notifications Disabled")
            }
        }
        
        @objc private func smsSwitchValueChanged(_ sender: UISwitch) {
               // Handle the SMS switch value change
               if sender.isOn {
                   print("SMS Notifications Enabled")
               } else {
                   print("SMS Notifications Disabled")
               }
           }
        
        private func createSeparator() -> UIView {
            let separator = UIView()
            separator.backgroundColor = UIColor.lightGray
            separator.translatesAutoresizingMaskIntoConstraints = false
            return separator
        }
        
        private func  setUpContraints() {
            NSLayoutConstraint.activate([
                emailbackgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                emailbackgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                
                emailbackgroundViewContainer.heightAnchor.constraint(equalToConstant: 50),
                emailbackgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
               
             emailImageView.centerXAnchor.constraint(equalTo: emailbackgroundViewContainer.centerXAnchor),
             emailImageView.centerYAnchor.constraint(equalTo: emailbackgroundViewContainer.centerYAnchor),
             emailImageView.widthAnchor.constraint(equalTo: emailbackgroundViewContainer.widthAnchor, multiplier: 0.4),
            emailImageView.heightAnchor.constraint(equalTo: emailbackgroundViewContainer.heightAnchor, multiplier: 0.2),
               
              emailNotify.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            emailNotify.leadingAnchor.constraint(equalTo: emailbackgroundViewContainer.trailingAnchor, constant: 10),
               emailNotifySwitch.centerYAnchor.constraint(equalTo: emailNotify.centerYAnchor),
               emailNotifySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
               
                emailType.topAnchor.constraint(equalTo: smsBackgroundViewContainer.bottomAnchor, constant: 30),
             emailType.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                
        smsBackgroundViewContainer.topAnchor.constraint(equalTo: emailbackgroundViewContainer.bottomAnchor, constant: 30),
            smsBackgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                            smsBackgroundViewContainer.heightAnchor.constraint(equalToConstant: 50),
                            smsBackgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
                smsImageView.centerXAnchor.constraint(equalTo: smsBackgroundViewContainer.centerXAnchor),
                           smsImageView.centerYAnchor.constraint(equalTo: smsBackgroundViewContainer.centerYAnchor),
                           smsImageView.widthAnchor.constraint(equalTo: smsBackgroundViewContainer.widthAnchor, multiplier: 0.4),
                smsImageView.heightAnchor.constraint(equalTo: smsBackgroundViewContainer.heightAnchor, multiplier: 0.4),
                smsNotify.topAnchor.constraint(equalTo: smsBackgroundViewContainer.topAnchor),
                smsNotify.leadingAnchor.constraint(equalTo: smsBackgroundViewContainer.trailingAnchor, constant: 10),
               smsNotifySwitch.centerYAnchor.constraint(equalTo: smsNotify.centerYAnchor),
                            smsNotifySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                            
                          
                            
            ])
            
            let separator1 = createSeparator()
            contentView.addSubview(separator1)
          

            NSLayoutConstraint.activate([
                separator1.topAnchor.constraint(equalTo: emailType.bottomAnchor, constant: 8),
                separator1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                separator1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                separator1.heightAnchor.constraint(equalToConstant: 1),

              
            ])
            
        }

    }


