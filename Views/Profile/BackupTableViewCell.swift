//
//  BackupTableViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 12/05/2024.
//

import UIKit

class BackupTableViewCell: UITableViewCell {

    static let identifier = "BackupTableViewCell"
    
    private  let backupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
        
    }()
    
    private let backupLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backupImageView.image = UIImage(systemName: "arrow.clockwise")
        backupLabel.text = "Backup and Restore"
        contentView.addSubview(backupImageView)
        contentView .addSubview(backupLabel)
        setupContraint()

        // Configure the view for the selected state
    }
    private func setupContraint() {
        NSLayoutConstraint.activate([
            backupImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backupImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backupImageView.heightAnchor.constraint(equalToConstant: 30),
            backupImageView.widthAnchor.constraint(equalToConstant: 30),
            
            backupLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            backupLabel.leadingAnchor.constraint(equalTo: backupImageView.trailingAnchor, constant: 10)
            
        ])
        
    }

}
