//
//  IncomeSectionCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 04/04/2024.
//

import UIKit
import CoreData

class IncomeSectionCollectionViewCell: UICollectionViewCell{
    private let backgroundViewContainer: UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           view.layer.cornerRadius = 5
           view.layer.borderWidth = 2.0
           view.layer.borderColor = UIColor.systemGray4.cgColor
           return view
       }()
       
       private let incomeIconImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.translatesAutoresizingMaskIntoConstraints = false
           imageView.contentMode = .scaleAspectFit
           return imageView
       }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
       
       private let nameLabel: UILabel = {
           let label = UILabel()
           label.textAlignment = .right
           label.textColor = .systemGray
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       private let amountLabel: UILabel = {
           let label = UILabel()
           label.textAlignment = .right
           label.textColor = .green
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let dashLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .green
        label.text = "+"
        label.font = .systemFont(ofSize: 25, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
       
       // Initializer
       override init(frame: CGRect) {
           super.init(frame: frame)
           contentView.addSubview(backgroundViewContainer)
           addSubview(incomeIconImageView)
           addSubview(nameLabel)
           addSubview(amountLabel)
           addSubview(dashLabel)
           addSubview(timeLabel)
           setupConstraints()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       // Configure cell with data
       func configure(with categoryName: String, totalAmount: String) {
           nameLabel.text = categoryName
           amountLabel.text = totalAmount
           
           //iconImageView.image = icon
       }
       
       // Set up constraints
       private func setupConstraints() {
           NSLayoutConstraint.activate([
               
               
               backgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                           backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                           backgroundViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                           backgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
                          
             incomeIconImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
                           incomeIconImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
                          incomeIconImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.7), // Adjust the multiplier
                          incomeIconImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.7),
               nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
               nameLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
               
               timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
               timeLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
               dashLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
               dashLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -90),
               
               amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
               amountLabel.leadingAnchor.constraint(equalTo: dashLabel.trailingAnchor)
              
           ])
       }

    
    
}


//func updateIncomeUI() {
//    guard let fetchedIncomeObjects = fetchedResultController?.fetchedObjects else {
//        print("No fetched income objects found.")
//        return
//    }
//
//    AddedItems = fetchedIncomeObjects.map { income in
//        return UserIncomeItem(income: income.income!,
//                              category: income.category!,
//                              itemName: income.source!,
//                              time: income.time!,
//                              date: income.date!,
//                              image: nil,
//                              categoryBackgroundColor: backgroundColors(for: income.category!))
//    }
//    let uniqueCategories = Set(AddedItems.map { $0.category })
//
//    incomeCategories = uniqueCategories.map { category in
//        let icon: String // Dynamically determine the icon based on the category name
//
//        // Update the following switch block as needed to assign appropriate icons to income categories
//        switch category {
//        case "Salary":
//            icon = "briefcase.fill"
//        case "FreeLance":
//            icon = "laptopcomputer"
//        case "Business":
//            icon = "building.columns"
//        case "Gift":
//            icon = "gift"
//        case "Alimony":
//            icon = "figure.2.and.child.holdinghands"
//        case "Dividend":
//            icon = "chart.line.uptrend.xyaxis"
//        case "Royalties":
//            icon = "music.note"
//        case "Rental":
//            icon = "house"
//        case "Grants":
//            icon = "graduationcap"
//        case "Bonuses":
//            icon = "dollarsign"
//        default:
//            icon = "defaultIcon"
//        }
//
//        return IncomeCategory(name: category, icon: icon)
//    }
//
//    // Sort income categories based on the total income
//    incomeCategories.sort { category1, category2 in
//        let totalIncome1 = totalIncomeAmount(for: category1.name)
//        let totalIncome2 = totalIncomeAmount(for: category2.name)
//        return Double(totalIncome1.replacingOccurrences(of: "₦", with: "")) ?? 0.0 > Double(totalIncome2.replacingOccurrences(of: "₦", with: "")) ?? 0.0
//    }
//
//    // Display only the top income categories (e.g., top 3 categories)
//    let numberOfTopIncomeCategoriesToShow = min(3, incomeCategories.count)
//    for index in 0..<numberOfTopIncomeCategoriesToShow {
//        let categoryName = incomeCategories[index].name
//        let totalAmount = totalIncomeAmount(for: categoryName)
//        let indexPath = IndexPath(row: index, section: 4)
//        configureTopIncomeCell(with: categoryName, totalAmount: totalAmount)
//    }
//}
