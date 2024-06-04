//
//  TodayCollectionReusableView.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 20/02/2024.
//

import UIKit



class TodayCollectionReusableView: UICollectionReusableView {
    static let identifier = "TodayCollectionReusableView"
    let currentDate = Date()

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()
   
    
    
    
    private let yesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
        addSubview(yesLabel)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 15, y: 0, width: self.frame.width - 30, height: self.frame.height / 2)
               
               // Set the frame for the 'yesLabel' below the 'label'
               yesLabel.frame = CGRect(x: 15, y: self.frame.height / 2, width: self.frame.width - 30, height: self.frame.height / 2)
    }

    func configure(todayItems: [UserExpenseItem], yesterdayItems: [UserExpenseItem]) {
                // Assuming items contains only items for the "Today" or "Yesterday" section
                let todayText = todayItems.isEmpty ? "" : todayItems[0].itemName
                let yesterdayText = yesterdayItems.isEmpty ? "" : yesterdayItems[0].itemName

                // Now you can use todayText and yesterdayText to set your label text or handle as needed
                label.text = "\(todayText)"
            yesLabel.text = "\(yesterdayText)"
            
           
            }
}
