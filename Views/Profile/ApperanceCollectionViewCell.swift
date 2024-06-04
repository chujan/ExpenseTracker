//
//  ApperanceCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 15/05/2024.
//

import UIKit

class ApperanceCollectionViewCell: UICollectionViewCell {
    static let identifier = "ApperanceCollectionViewCell"
    
    let appearanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Appearance"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    let sameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Same as device"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let deviceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Uses light or dark mode on your device settings"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    let lightLabel: UILabel = {
        let label = UILabel()
        label.text = "Light"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let darkLabel: UILabel = {
        let label = UILabel()
        label.text = "Dark"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let darkNotifySwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.isOn = false // Set default state
        return toggleSwitch
    }()
    
    let lightNotifySwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.isOn = false // Set default state
        return toggleSwitch
    }()
    
    let sameNotifySwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.isOn = false // Set default state
        return toggleSwitch
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(appearanceLabel)
        contentView.addSubview(darkLabel)
        contentView.addSubview(lightLabel)
        contentView.addSubview(sameLabel)
        contentView.addSubview(deviceLabel)
        contentView.addSubview(darkNotifySwitch)
        contentView.addSubview(lightNotifySwitch)
        contentView.addSubview(sameNotifySwitch)
        darkNotifySwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        lightNotifySwitch.addTarget(self, action: #selector(smsSwitchValueChanged(_:)), for: .valueChanged)
        sameNotifySwitch.addTarget(self, action: #selector(sameValueChanged(_:)), for: .valueChanged)

        setUpConstraints()
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            updateAppearance(to: .dark)
        }
    }
    
    @objc private func smsSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            updateAppearance(to: .light)
        }
    }
    
    @objc private func sameValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            updateAppearance(to: .unspecified)
        }
    }
    
    private func updateAppearance(to style: UIUserInterfaceStyle) {
        if let window = UIApplication.shared.windows.first {
            window.overrideUserInterfaceStyle = style
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            appearanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            appearanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            appearanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            sameLabel.topAnchor.constraint(equalTo: appearanceLabel.bottomAnchor, constant: 50),
            sameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            sameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            sameNotifySwitch.centerYAnchor.constraint(equalTo: sameLabel.centerYAnchor),
            sameNotifySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            deviceLabel.topAnchor.constraint(equalTo: sameLabel.bottomAnchor, constant: 20),
            deviceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            deviceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            lightLabel.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor, constant: 80),
            lightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            lightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            lightNotifySwitch.centerYAnchor.constraint(equalTo: lightLabel.centerYAnchor),
            lightNotifySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            darkLabel.topAnchor.constraint(equalTo: lightLabel.bottomAnchor, constant: 50),
            darkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            darkLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            darkNotifySwitch.centerYAnchor.constraint(equalTo: darkLabel.centerYAnchor),
            darkNotifySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
}
