//
//  MessageViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 09/05/2024.
//

import UIKit
import CoreData

class MessageViewController: UIViewController {
    var selectedCategory: String?
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return MessageViewController.createSectionLayout(section: sectionIndex)
        
    })
   
    
    
    var categories: [ExpenseCategory] = [
        ExpenseCategory(name: "Recurring", icon: "arrow.triangle.2.circlepath"),
        ExpenseCategory(name: "Grocery", icon: "house"),
        ExpenseCategory(name: "Gadgets", icon: "oven"),
        ExpenseCategory(name: "Fuel", icon: "fuelpump"),
        ExpenseCategory(name: "Online", icon: "globe"),
        ExpenseCategory(name: "Shopping", icon: "bag"),
        ExpenseCategory(name: "Net Banking", icon: "building.columns"),
        ExpenseCategory(name: "Food", icon: "fork.knife"),
        ExpenseCategory(name: "Travels", icon: "airplane"),
        ExpenseCategory(name: "Sport", icon: "figure.run"),
        ExpenseCategory(name: "Kids", icon: "figure.and.child.holdinghands"),
        ExpenseCategory(name: "Cinema", icon: "film")
    ]
    var userAddedItems: [UserExpenseItem] = []
    var categoryTotalAmounts: [String: Double] = [:]
       
       // Modify the initializer to accept categoryTotalAmounts
       init(categoryTotalAmounts: [String: Double], userAddedItems: [UserExpenseItem]) {
           self.categoryTotalAmounts = categoryTotalAmounts
           self.userAddedItems = userAddedItems
           super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
      
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AddedCategoryCollectionViewCell.self, forCellWithReuseIdentifier: AddedCategoryCollectionViewCell.identifier)
        collectionView.register(MessageTitleCollectionViewCell.self, forCellWithReuseIdentifier: MessageTitleCollectionViewCell.identifier)
        collectionView.register(MessageDetailCollectionViewCell.self, forCellWithReuseIdentifier: MessageDetailCollectionViewCell.identifier)
       

        print("Categories: \(categoryTotalAmounts.count)")
        print("Categories: \(categoryTotalAmounts)")
                print("User Added Items: \(userAddedItems)")
    }
    
   
    
    lazy var managedObjectContext: NSManagedObjectContext = {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }()
    
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.bounds = view.bounds
        if #available(iOS 11.0, *) {
            collectionView.frame = view.safeAreaLayoutGuide.layoutFrame
        } else {
            collectionView.frame = view.bounds
        }
    }
    
    
    
    
    func calculateTotalIncome() -> Double {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Income")
        fetchRequest.resultType = .dictionaryResultType
        
        let sumExpression = NSExpressionDescription()
        sumExpression.name = "totalIncome"
        sumExpression.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "income")])
        sumExpression.expressionResultType = .doubleAttributeType
        
        fetchRequest.propertiesToFetch = [sumExpression]
       
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            
            if let dict = result.first as? [String: Double], let totalIncome = dict["totalIncome"] {
                return totalIncome
            } else {
                return 0.0
            }
        } catch {
            print("Error calculating total income: \(error)")
            return 0.0
        }
    }
    
    
    func calculateTotalExpenses() -> Double {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        fetchRequest.resultType = .dictionaryResultType
        
        let sumExpression = NSExpressionDescription()
        sumExpression.name = "totalExpense"
        sumExpression.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "amount")])
        sumExpression.expressionResultType = .doubleAttributeType
        
        fetchRequest.propertiesToFetch = [sumExpression]
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            
            if let dict = result.first as? [String: Double], let totalExpense = dict["totalExpense"] {
                return totalExpense
            } else {
                return 0.0
            }
        } catch {
            print("Error calculating total expenses: \(error)")
            return 0.0
        }
    }





    
    // Assuming this method is called when the user selects a category
    func didSelectCategory(_ category: String) {
        // Set the selected category
        selectedCategory = category
        
        // Reload the collection view to reflect the selected category
        collectionView.reloadData()
    }
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
      
        switch section {
            
             case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)))
       item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
          
            return section
        case 1:
            
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(0.7))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return section
            
       
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
                 let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), repeatingSubitem: item, count: 1)
                 let section = NSCollectionLayoutSection(group: group)
               
                 return section
       

            
            
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), repeatingSubitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            
            
            return section
        }
    }
    

  

}
extension MessageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
            
        case 2:
            return userAddedItems.count
            
        default:
            return 0
        }
      
    }
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedCategoryCollectionViewCell.identifier, for: indexPath) as? AddedCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }

            // Check if a category is selected
            guard let selectedCategory = selectedCategory else {
                // Handle the case where no category is selected
                return cell
            }

            // Retrieve total amount for the selected category
            let totalAmount = categoryTotalAmounts[selectedCategory] ?? 0.0

            // Configure the cell with selected category name and total amount
            cell.configure(categoryTotalAmount: totalAmount, categoryName: selectedCategory, categories: categories)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageTitleCollectionViewCell.identifier, for: indexPath) as! MessageTitleCollectionViewCell
            cell.configure()
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageDetailCollectionViewCell.identifier, for: indexPath) as? MessageDetailCollectionViewCell else {
                return UICollectionViewCell()
            }
            let totalIncome = calculateTotalIncome()
            let totalExpense = calculateTotalExpenses()
            let totalBalance = calculateTotalIncome() - calculateTotalExpenses()
            let viewModel = userAddedItems[indexPath.row]
          
            cell.configure(with: viewModel, remainingBalance: totalBalance)
           
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}



    
    

