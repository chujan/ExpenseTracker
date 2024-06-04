//
//  MessageDetailCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 10/05/2024.
//

import UIKit

class MessageDetailCollectionViewCell: UICollectionViewCell {
    static let identifier = "MessageDetailCollectionViewCell"
    private let notificationCell = NotificationCollectionViewCell()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .light)
        
        return label
        
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .red
        
        return label
        
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 4
        return label
        
    }()
    
    let dashLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .red
        label.text = "-"
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemIndigo
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .light)
        
        return label
        
    }()
    
    func updateBadge(count: Int) {
            notificationCell.updateBadge(count: count)
        }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(dashLabel)
        contentView.backgroundColor = .secondarySystemBackground
        
        
        contentView.layer.cornerRadius = 15
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
        
        contentView.layer.borderColor = UIColor.white.cgColor
      
        
        setContraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setContraint() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                   dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                   dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                   
                   timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10), // Adjusted constant for spacing
                   timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                   timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            dashLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dashLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: -80),
            
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            amountLabel.leadingAnchor.constraint(equalTo: dashLabel.trailingAnchor),
            detailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            
               ])
            
        
    }
    
    
    
    public func configure(with recent: UserExpenseItem, remainingBalance: Double) {
        let nairaAmount = "₦" + recent.amount
        amountLabel.text = nairaAmount
        
        timeLabel.text = recent.time
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let formattedDate = dateFormatter.string(from: recent.date)
        dateLabel.text = formattedDate
        
        
        guard let amount = Int(recent.amount) else {
            // Handle the case where recent.amount cannot be converted to an integer
            return
        }

        // Construct the message
        let message = "Money Out Alert!, You've spent \(nairaAmount) 0n \(recent.itemName) on \(recent.date) \(recent.time) Avl bal:\(remainingBalance)"

        // Update the detail label with the message
        detailLabel.text = message

    }

    
    
    
}
