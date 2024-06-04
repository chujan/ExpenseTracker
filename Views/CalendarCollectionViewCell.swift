//
//  CalendarCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 13/02/2024.
//

import UIKit



class CalendarCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalendarCollectionViewCell"
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let weekLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(monthLabel)
        contentView.addSubview(weekLabel)
        contentView.addSubview(dateLabel)
       
        contentView.backgroundColor = .clear
        
       
      
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        weekLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                   monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                   monthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                   
                   weekLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 2), // Adjust spacing if needed
                   weekLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                   weekLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                   
                   dateLabel.topAnchor.constraint(equalTo: weekLabel.bottomAnchor, constant: 2), // Adjust spacing if needed
                   dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                   dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                   dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func configure(months: String, date: String, week: String, isToday: Bool) {
            monthLabel.text = months
            dateLabel.text = date
            weekLabel.text = week

            
        }
    
   
}
