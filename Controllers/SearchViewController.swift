//
//  SearchViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 24/04/2024.
//

import UIKit
import PanModal
import CoreData

class SearchViewController: UIViewController,  AddViewControllerDelegate {
    func didSaveExpenseItem(_ expenseItem: Expense) {
        // Handle the saved expense item here
        // For example, you can add it to your userAddedItems array and update the UI
        userAddedItems.append(UserExpenseItem(amount: expenseItem.amount!, category: expenseItem.category!, itemName: expenseItem.itemName!, time: expenseItem.time!, date: expenseItem.date!, image: nil, categoryBackgroundColor: backgroundColor(for: expenseItem.category!)))
        
        
        
        
        
        // updateUI()
        
        // Print statement to confirm the item is passed
        print("Expense item passed to TransactionViewController: \(expenseItem)")
    }
    lazy var managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    
    
    let buttonCell = TransactionButtonCollectionViewCell()
    
    func backgroundColor(for category: String) -> UIColor {
        switch category {
        case "Recurring":
            return UIColor.systemBlue
        case "Grocery":
            return UIColor.systemGreen
        case "Food":
            return UIColor.systemOrange
        case "Shopping":
            return UIColor.systemPurple
        // Add more cases as needed for other categories
        default:
            return UIColor.systemGray
        }
    }
    
    private func updateUI() {
        // Fetch all expenses from Core Data
       // let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest(entityName: "Expense")
        
        var predicate: NSPredicate?
        var buttonTitle = ""
        var startDate: Date?
        var endDate: Date?
        
        switch selectedCategory {
        case "Today":
            startDate = Calendar.current.startOfDay(for: Date())
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate!)
            predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as! NSDate, endDate as! NSDate)
            buttonTitle = "Today"
        case "Weekly":
            let startDate = Date().startOfWeek()
            let endDate = Date().endOfWeek()
            predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
            buttonTitle = "Weekly"
           
        case "Monthly":
            let startDate = Date().startOfMonth()
            let endDate = Date().endOfMonth()
            predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
            buttonTitle = "Monthly"
        case "Yearly":
            let startDate = Date().startOfYear()
            let endDate = Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: startDate)!
            predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
            buttonTitle = "Yearly"
        default:
            break
        }
        
        
        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest<Expense>(entityName: "Expense")
        fetchRequest.predicate = predicate
        
        // Update the button's title based on the selected time frame
        let button = createButton(title: buttonTitle, action: #selector(timeFrameButtonTapped))
        
        // Add the button to your button cell's collection
        buttonCell.configure(with: [button]) { selectedCategory in
            self.selectedCategory = selectedCategory
            self.updateUI()
        }
        do {
            let expenses = try managedObjectContext.fetch(fetchRequest)
            
            // Convert fetched expenses to UserExpenseItem objects
            userAddedItems = expenses.map { expense in
                return UserExpenseItem(amount: expense.amount ?? "",
                                       category: expense.category ?? "",
                                       itemName: expense.itemName ?? "",
                                       time: expense.time ?? "",
                                       date: expense.date ?? Date(),
                                       image: expense.image,
                                       categoryBackgroundColor: backgroundColor(for: expense.category ?? ""))
            }
            
            // Reload the collection view on the main thread
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            print("Error fetching expenses: \(error)")
        }
    }



    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return SearchViewController.createSectionLayout(section: sectionIndex)
        
    })
    
    var selectedCategory: String? {
        didSet {
            updateUI()
        }
    }


    var userAddedItems: [UserExpenseItem] = []
    
    
    private func createButton(title: String, action: Selector) -> UIButton {
            let button = UIButton()
           
           
            //button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            
            button.setTitle(title, for: .normal)
            button.setTitleColor(.darkGray, for: .normal)
            button.addTarget(self, action: action, for: .touchUpInside)
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
        if title == selectedCategory {
                button.setTitleColor(.systemIndigo, for: .normal)
            } else {
                button.setTitleColor(.darkGray, for: .normal)
            }
            
            return button
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        updateUI()
        selectedCategory = "Yearly"
        collectionView.register(AddedCollectionViewCell.self, forCellWithReuseIdentifier: AddedCollectionViewCell.identifier)
        collectionView.register(SearchButtonCollectionViewCell.self, forCellWithReuseIdentifier: SearchButtonCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let buttonCell = SearchButtonCollectionViewCell()
        buttonCell.configure(with: [
                    createButton(title: "Today", action: #selector(todayButtonTapped)),
                    createButton(title: "Weekly", action: #selector(weeklyButtonTapped)),
                    createButton(title: "Monthly", action: #selector(monthlyButtonTapped)),
                    createButton(title: "Yearly", action: #selector(yearlyButtonTapped)),
                   
                ]) { selectedCategory in
                    self.selectedCategory = selectedCategory
                    self.updateUI()
                }

       
    }
    
    @objc func timeFrameButtonTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {
            return // Ensure button title is not nil
        }
        // Handle the button tap action here
        print("Time frame button tapped: \(buttonTitle)")

        // Update selectedCategory based on the button tapped
        selectedCategory = buttonTitle

       
        updateUI()
    }

    
    @objc private func todayButtonTapped () {
        let button = createButton(title: "Today", action: #selector(todayButtonTapped))
        timeFrameButtonTapped(button)
       
        
    }
    
    @objc private func weeklyButtonTapped() {
        let button = createButton(title: "Weekly", action: #selector(weeklyButtonTapped))
        timeFrameButtonTapped(button)
        //updateUI()
    }

    @objc private func monthlyButtonTapped() {
        let button = createButton(title: "Monthly", action: #selector(monthlyButtonTapped))
        timeFrameButtonTapped(button)
        updateUI()
    }

    @objc private func yearlyButtonTapped() {
        let button = createButton(title: "Yearly", action: #selector(yearlyButtonTapped))
        timeFrameButtonTapped(button)
        updateUI()
    }

    
    
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
          collectionView.frame = view.bounds
        }
    
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
       
        switch section {
        case 0:
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 15, bottom: 10, trailing: 15)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return section
            
       
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 15, bottom: 0, trailing: 15)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), repeatingSubitem: item, count: 1)
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
extension SearchViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(400)
    }
}
extension SearchViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Check if the shown view controller is the expected type
        if let homeDetailViewController = viewController as? TransactionViewController {
            // Do something with the shown view controller if needed
            print("Did show HomeDetailViewController")
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return userAddedItems.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
    
        case 0:
            guard let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchButtonCollectionViewCell.identifier, for: indexPath) as? SearchButtonCollectionViewCell else {
                return UICollectionViewCell()
            }
            buttonCell.configure(with: [
                createButton(title: "Today", action: #selector(todayButtonTapped)),
                createButton(title: "Weekly", action: #selector(weeklyButtonTapped)),
                createButton(title: "Monthly", action: #selector(monthlyButtonTapped)),
                createButton(title: "Yearly", action: #selector(yearlyButtonTapped)),
            ]) { selectedCategory in
                self.selectedCategory = selectedCategory
                self.updateUI()
                
            }
            
            return buttonCell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedCollectionViewCell.identifier, for: indexPath) as? AddedCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = userAddedItems[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    
}


