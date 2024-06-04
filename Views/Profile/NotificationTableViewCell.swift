//
//  NotificationTableViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 15/05/2024.
//

import UIKit


class NotificationTableViewCell: UITableViewCell {
    static let identifier = "NotificationTableViewCell"
    
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
    
    let notifyType: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = "Notifications about what your remaining balance is"
        label.numberOfLines = 0
        return label
    }()
    
    let ChooseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.text = "Choose what you want to hear about"
        label.numberOfLines = 0
        return label
    }()
    
    
    let allowNotify: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.text = "Allow notifications"
        return label
    }()
    
    let allowNotifySwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.isOn = false // Set default state
        return toggleSwitch
    }()
    
    private let separator1: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setUpSubviews()
        setUpConstraints()
        allowNotifySwitch.isOn = UserDefaults.standard.bool(forKey: "notificationsEnabled")
    }
    
    private func setUpSubviews() {
        contentView.addSubview(backgroundViewContainer)
        backgroundViewContainer.addSubview(NotificationImageView)
        contentView.addSubview(notifyType)
        contentView.addSubview(allowNotify)
        contentView.addSubview(allowNotifySwitch)
        contentView.addSubview(ChooseLabel)
        contentView.addSubview(separator1)
        
        backgroundViewContainer.layer.cornerRadius = 25
        backgroundViewContainer.layer.masksToBounds = true
        contentView.backgroundColor = .systemBackground
        NotificationImageView.tintColor = .white
        allowNotifySwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
            UserDefaults.standard.set(sender.isOn, forKey: "notificationsEnabled")
            if sender.isOn {
                print("Notifications Enabled")
            } else {
                print("Notifications Disabled")
            }
        }
    
  
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            ChooseLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 70),
            ChooseLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            ChooseLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            
            
            backgroundViewContainer.topAnchor.constraint(equalTo: ChooseLabel.bottomAnchor, constant: 20),
            backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 50),
            
            NotificationImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
            NotificationImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
            NotificationImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.4),
            NotificationImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.4),
            
            allowNotify.topAnchor.constraint(equalTo: ChooseLabel.topAnchor, constant: 40),
            allowNotify.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
            
            allowNotifySwitch.centerYAnchor.constraint(equalTo: allowNotify.centerYAnchor),
            allowNotifySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            notifyType.topAnchor.constraint(equalTo: backgroundViewContainer.bottomAnchor, constant: 30),
            notifyType.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            notifyType.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            separator1.topAnchor.constraint(equalTo: notifyType.bottomAnchor, constant: 10),
            separator1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator1.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

