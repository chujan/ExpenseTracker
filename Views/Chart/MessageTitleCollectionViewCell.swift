//
//  MessageTitleCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 10/05/2024.
//

import UIKit

class MessageTitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "MessageTitleCollectionViewCell"
    
    private let stackViewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stackViewTitleLabel)
        
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        NSLayoutConstraint.activate([
            stackViewTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                    stackViewTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                    stackViewTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10), // Updated
                    stackViewTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
           
        ])
        
       
    }

    public func configure() {
        stackViewTitleLabel.text = "Details"
    }
    
    
}
