//
//  SearchCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 21/04/2024.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchCollectionViewCell"
    
    private let nameLabal: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabal)
        setUpContraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        private func setUpContraints() {
            NSLayoutConstraint.activate([
                nameLabal.topAnchor.constraint(equalTo: contentView.topAnchor),
                nameLabal.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                nameLabal.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
           
        }
    
    public func configure(with recent: UserExpenseItem) {
        nameLabal.text = recent.itemName
        
    }
    
    
}
