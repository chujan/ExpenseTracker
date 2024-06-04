//
//  NotificationViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 09/05/2024.
//

import UIKit
import CoreData

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    var newItemsCount: Int = 0
}


class NotificationViewController: UIViewController {
    var newItemsCount = 0
        
    var userAddedItems: [UserExpenseItem] = []
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
             let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), repeatingSubitem: item, count: 1)
             let section = NSCollectionLayoutSection(group: group)
           
             return section
   

       }))
    
    init(userAddedItems: [UserExpenseItem]) {
        self .userAddedItems = userAddedItems
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.register(MessageDetailCollectionViewCell.self, forCellWithReuseIdentifier: MessageDetailCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationManager.shared.newItemsCount = 0
       
        

        
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
          collectionView.frame = view.bounds
       
      
        }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear called")
        
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
            print("Badge number set to 0")
        }
        
        NotificationManager.shared.newItemsCount = 0
    }

    
    lazy var managedObjectContext: NSManagedObjectContext = {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }()
    
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
    
   

    
}

extension NotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userAddedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageDetailCollectionViewCell.identifier, for: indexPath) as? MessageDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        let totalIncome = calculateTotalIncome()
        let totalExpense = calculateTotalExpenses()
        let totalBalance = calculateTotalIncome() - calculateTotalExpenses()
        let viewModel = userAddedItems[indexPath.row]
      
        cell.configure(with: viewModel, remainingBalance: totalBalance)
       
        return cell
        
    }
    
    
}
