//
//  BudgetViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 07/04/2024.
//

import UIKit
import PanModal
import CoreData

enum SectionType: Int {
    case RecentExpenses
    case Categories
}



class BudgetViewController: UIViewController, AddBudgetControllerDelegate, AddExpenseViewControllerDelegate  {
    func didSaveExpenseItem(_ expenseItem: Expense) {
        userAddedItems.append(UserExpenseItem(amount: expenseItem.amount!, category: expenseItem.category!, itemName: expenseItem.itemName!, time: expenseItem.time!, date: expenseItem.date!, image: nil, categoryBackgroundColor: backgroundColor(for: expenseItem.category!)))
        
    
            updateUIs()
       
    }
    
    func didSaveExpenseItem(_ expenseItem: Category) {
        userAdded.append(budgetAddedItem(amount: expenseItem.amount!, category: expenseItem.category!,   image: nil, categoryBackgroundColor: backgroundColor(for: expenseItem.category!), date: date))
        
        
            
        updateUI()
        
        
    }
   
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
    
    let buttonCell = ButtonCollectionViewCell()
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return BudgetViewController.createSectionLayout(section: sectionIndex)
        
    })
    var fetchedResultsController: NSFetchedResultsController<Expense>?
    var userAddedItems: [UserExpenseItem] = []
    var userAdded: [budgetAddedItem] = []
    private var cell: BudgetCollectionViewCell?
    
    var  categories: [ExpenseCategory] = []
          
          
    
    var selectedCategory: String? {
        didSet {
            updateUI()
        }
    }
    var date = Date()
    private func createButton(title: String, action: Selector) -> UIButton {
            let button = UIButton()
           
           
            button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            
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

    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = false
                       // or adjust its appearance
      tabBarController?.tabBar.isTranslucent = false
         
        title = "Budgets"
        view.addSubview(collectionView)
        let totalMonthBudget = totalAmountForMonthByCategory()
        let totalyearBudget =  totalAmountForYearByCategory()
        print("Total budget for the year: \(totalyearBudget)")
            
            
            print("Total budget for the month: \(totalMonthBudget)")
            
        
        updateUI()
        selectedCategory = "All"
      
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        collectionView.register(BudgetCollectionViewCell.self, forCellWithReuseIdentifier: BudgetCollectionViewCell.identifer)
        collectionView.register(BudgetHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BudgetHeaderCollectionReusableView.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeader")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        // Inside your viewDidLoad() or wherever you're setting up the buttons
       
        let buttonCell = ButtonCollectionViewCell()
        buttonCell.configure(with: [
                    createButton(title: "All", action: #selector(AlltypeButtonTapped)),
                    createButton(title: "Weekly", action: #selector(weeklyButtonTapped)),
                    createButton(title: "Monthly", action: #selector(monthlyButtonTapped)),
                    createButton(title: "Yearly", action: #selector(yearlyButtonTapped)),
                   
        ]) { selectedCategory in
            self.selectedCategory = selectedCategory
            self.updateUI()
        }
        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest<Expense>(entityName: "Expense")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(
               fetchRequest: fetchRequest,
               managedObjectContext: managedObjectContext,
               sectionNameKeyPath: nil,
               cacheName: nil
           )
        
        fetchedResultsController?.delegate = self

        do {
            try fetchedResultsController?.performFetch()
            updateUIs()
        } catch {
            print("Error fetching expenses: \(error)")
        }

       
    }
    
    
    public func updateUIs() {
        
        guard let fetchedObjects = fetchedResultsController?.fetchedObjects else {
            print("No fetched objects found.")
            return
        }

        userAddedItems = fetchedObjects.map { expense in
            return UserExpenseItem(amount: expense.amount!,
                                   category: expense.category!,
                                   itemName: expense.itemName ?? "",

                                   time: expense.time ?? "",
                                   date: expense.date ?? Date(),
                                   image: expense.image,
                                   categoryBackgroundColor: backgroundColor(for: expense.category!))
        }

        let uniqueCategories = Set(userAddedItems.map { $0.category })

        categories = uniqueCategories.map { category in
            // Determine the icon dynamically based on the category name
            let icon: String

            switch category {
            case "Recurring":
                icon = "arrow.triangle.2.circlepath"
            case "Grocery":
                icon = "house"
            case "Food":
                icon = "fork.knife"
            case "Fuel":
                icon = "fuelpump"
            case "Online":
                icon = "globe"
            case "Shopping":
                icon = "bag"
            case "Net Banking":
                icon = "building.columns"
            case "Travels":
                icon = "airplane"
            case "Sport":
                icon = "figure.run"
            case "Kids":
                icon = "figure.and.child.holdinghands"
            case "Cinema":
                icon = "film"
            default:
                icon = "defaultIcon"
            }

            return ExpenseCategory(name: category, icon: icon)
        }

        for category in categories {
                let total = totalAmount(for: category.name)
                print("Total amount for \(category.name): \(total)")
              
            }
    }
    
    
    private func totalAmount(for category: String) -> Double {
        var totalAmount: Double = 0.0

        for expenseItem in userAddedItems where expenseItem.category == category {
            if let amount = Double(expenseItem.amount) {
                totalAmount += amount
            }
        }
        print("Total amount for \(category): \(totalAmount)")
        return totalAmount
    }

    
    

    

    
    
   



    private func calculateTotalAmountToSubtract(for category: String, in items: [budgetAddedItem]) -> Double {
        var totalAmountToSubtract: Double = 0.0
        for item in items where item.category == category {
            if let amount = Double(item.amount) {
                totalAmountToSubtract += amount
            }
        }
        return totalAmountToSubtract
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


    
    private func updateUI() {
        
        if selectedCategory == "All" {
                // Fetch and display expenses without any predicate
                fetchAndDisplayAllExpenses()
                return
            }
        
        var predicate: NSPredicate?
        var buttonTitle = ""
        
        switch selectedCategory {
        case "Weekly":
            print("Selected category: Weekly")
            // Set predicate for weekly expenses
            predicate = constructWeeklyPredicate()
            buttonTitle = "Weekly"
            
        case "Monthly":
            print("Selected category: Monthly")
            // Set predicate for monthly expenses
            predicate = constructMonthlyPredicate()
            buttonTitle = "Monthly"
            
        case "Yearly":
            print("Selected category: Yearly")
            // Set predicate for yearly expenses
            predicate = constructYearlyPredicate()
            buttonTitle = "Yearly"
            
        default:
            // No specific time frame selected, fetch all expenses
            predicate = nil
            buttonTitle = "All"
        }
        
        // Update the button's title based on the selected time frame
        let button = createButton(title: buttonTitle, action: #selector(timeFrameButtonTapped))
        
        // Add the button to your button cell's collection
        buttonCell.configure(with: [button]) { selectedCategory in
            self.selectedCategory = selectedCategory
            self.updateUI()
        }
        
        // Fetch expenses based on the predicate
        if let predicate = predicate {
            let fetchRequest: NSFetchRequest<Category> = NSFetchRequest<Category>(entityName: "Category")
            fetchRequest.predicate = predicate
            
            do {
                let totalAmountByCategory: [String: Double]
                
                if selectedCategory == "Monthly" {
                    // Get total amount for each category in the month
                    totalAmountByCategory = totalAmountForMonthByCategory()
                } else if selectedCategory == "Yearly" {
                    // Get total amount for each category in the year
                    totalAmountByCategory = totalAmountForYearByCategory()
                } else  if  selectedCategory == "Weekly" {
                   totalAmountByCategory = totalAmountForWeekByCategory()
                    
                } else {
                    totalAmountByCategory = [:]
                }
                
                // Update the userAdded array with total amounts for each category
                updateUserAddedArrayWithTotalAmount(totalAmountByCategory)
                
                // Update UI after processing fetched expenses
                collectionView.reloadData()
                
            } catch {
                print("Error fetching expenses: \(error)")
            }
        }
    }
    
    
    private func fetchAndDisplayAllExpenses() {
        // Fetch all expenses without any predicate
        let fetchRequest: NSFetchRequest<Category> = NSFetchRequest<Category>(entityName: "Category")
        
        do {
            let categories = try managedObjectContext.fetch(fetchRequest)
            
            // Create a dictionary to hold unique categories
            var uniqueCategories: [String: budgetAddedItem] = [:]
            
            // Iterate through fetched categories
            for category in categories {
                // Check if the category already exists in the uniqueCategories dictionary
                if let existingCategory = uniqueCategories[category.category ?? ""] {
                    // If the category exists, update the amount
                    if let amount = Double(category.amount ?? "0"), let existingAmount = Double(existingCategory.amount) {
                        let updatedAmount = amount + existingAmount
                        uniqueCategories[category.category ?? ""] = budgetAddedItem(amount: "\(updatedAmount)",
                                                                                    category: category.category ?? "",
                                                                                    image: nil,
                                                                                    categoryBackgroundColor: UIColor.gray, // Default color
                                                                                    date: category.date ?? Date())
                    }
                } else {
                    // If the category doesn't exist, add it to the uniqueCategories dictionary
                    uniqueCategories[category.category ?? ""] = budgetAddedItem(amount: category.amount ?? "0",
                                                                                category: category.category ?? "",
                                                                                image: nil,
                                                                                categoryBackgroundColor: UIColor.gray, // Default color
                                                                                date: category.date ?? Date())
                }
            }
            
            // Convert the dictionary values (unique categories) back to an array
            userAdded = Array(uniqueCategories.values)
            updateUIs()
            
            // Reload the collectionView to update the UI
            collectionView.reloadData()
            
        } catch {
            print("Error fetching categories: \(error)")
        }
    }

    

    // Helper method to construct predicate for weekly expenses
    private func constructWeeklyPredicate() -> NSPredicate {
        let startDate = Date().startOfWeek()
        let endDate = Date().endOfWeek()
        return NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
    }

    // Helper method to construct predicate for monthly expenses
    private func constructMonthlyPredicate() -> NSPredicate {
        let startDate = Date().startOfMonth()
        let endDate = Date().endOfMonth()
        return NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
    }

    // Helper method to construct predicate for yearly expenses
    private func constructYearlyPredicate() -> NSPredicate {
        let startDate = Date().startOfYear()
        let endDate = Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: startDate)!
        return NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
    }

    // Helper method to update userAdded array with total amounts for each category
    private func updateUserAddedArrayWithTotalAmount(_ totalAmountByCategory: [String: Double]) {
        // Clear userAdded array before updating with new data
        userAdded.removeAll()
        
        for (category, totalAmount) in totalAmountByCategory {
            userAdded.append(budgetAddedItem(amount: "\(totalAmount)",
                                             category: category,
                                             image: nil,
                                             categoryBackgroundColor: UIColor.gray, // Default color
                                             date: Date()))
        }


    }


    
    private func indexPathForCategory(_ category: String) -> IndexPath? {
        // Iterate through userAdded to find the index path of the item with the given category
        for (index, item) in userAdded.enumerated() {
            if item.category == category {
                // If found, return the corresponding index path
                return IndexPath(row: index, section: 1)
            }
        }
        // If not found, return nil
        return nil
    }
    
    
    
    
    

    func subtractAmount(from category: String, amountToSubtract: Double, cell: BudgetCollectionViewCell) {
        var totalAmountDouble: Double = 0.0
        
        // Calculate the updated total amount
        for expenseItem in userAddedItems where expenseItem.category == category {
            if let amount = Double(expenseItem.amount) {
                totalAmountDouble += amount
            }
        }
        
        // Subtract the totalAmountDouble from amountToSubtract
        let updatedAmount = amountToSubtract - totalAmountDouble
        
        // Ensure updatedAmount is not negative
        let resultAmount = max(updatedAmount, 0.0)
        
        // Update the savedAmountLabel with the updated total amount
        cell.savedAmountLabel.text = "₦" + String(format: "%.2f", resultAmount)

        // Find the index path of the cell
        if let indexPath = collectionView.indexPath(for: cell) {
            // Reload only the cell at that index path
            collectionView.reloadItems(at: [indexPath])
        }
    }



    
       
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func calculateProgress(for category: String) -> Int {
        guard let budgetItem = userAdded.first(where: { $0.category == category }),
              let budgetAmount = Double(budgetItem.amount),
              budgetAmount != 0 // Check if budgetAmount is not zero
        else {
            return 0 // No budget item found for this category or budget amount is zero
        }
        
        var totalSpentAmount = totalAmount(for: category)
        
        // Check if the total spent amount exceeds the budget amount
        if totalSpentAmount > budgetAmount {
            // If so, set the total spent amount to the budget amount
            totalSpentAmount = budgetAmount
        }
        
        // Calculate the percentage of the budget spent
        let percentage = Int((totalSpentAmount / budgetAmount) * 100)
        
        return percentage
    }


    
    public func navigateToItemList() {
        let vc = AddBudgetViewController()
        presentPanModal(vc)
    }
    
    func addExpense(_ expenseItem: UserExpenseItem) {
        // Add expenseItem to userAddedItems
        userAddedItems.append(expenseItem)
        
        // Reload the collectionView
        collectionView.reloadData()
    }
    
    @objc private func AlltypeButtonTapped () {
        selectedCategory = "All"
      
        
        
        
       
    }
    @objc private func weeklyButtonTapped() {
        let button = createButton(title: "Weekly", action: #selector(weeklyButtonTapped))
        timeFrameButtonTapped(button)
        updateUI()
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
    
    func totalAmountForWeekByCategory() -> [String: Double] {
        var totalAmountByCategory: [String: Double] = [:]
        
        let startDate = Date().startOfWeek()
        let endDate = Date().endOfWeek()
        
        let fetchRequest: NSFetchRequest<Category> = NSFetchRequest<Category>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        
        do {
            let categories = try managedObjectContext.fetch(fetchRequest)
            for category in categories {
                if let amount = Double(category.amount ?? "0") {
                    totalAmountByCategory[category.category ?? ""] = (totalAmountByCategory[category.category ?? ""] ?? 0) + amount
                }
            }
            
            for (category, totalAmount) in totalAmountByCategory {
                print("Total amount for \(category) in the month: \(totalAmount)")
            }
            
            return totalAmountByCategory
        } catch {
            print("Error fetching categories: \(error)")
            return [:]
        }
    }

    
    // Calculate total amount for each category in the month
    func totalAmountForMonthByCategory() -> [String: Double] {
        var totalAmountByCategory: [String: Double] = [:]
        
        let startDate = Date().startOfMonth()
        let endDate = Date().endOfMonth()
        
        let fetchRequest: NSFetchRequest<Category> = NSFetchRequest<Category>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        
        do {
            let categories = try managedObjectContext.fetch(fetchRequest)
            for category in categories {
                if let amount = Double(category.amount ?? "0") {
                    totalAmountByCategory[category.category ?? ""] = (totalAmountByCategory[category.category ?? ""] ?? 0) + amount
                }
            }
            
            for (category, totalAmount) in totalAmountByCategory {
                print("Total amount for \(category) in the month: \(totalAmount)")
            }
            
            return totalAmountByCategory
        } catch {
            print("Error fetching categories: \(error)")
            return [:]
        }
    }
    
    // Calculate total amount for each category in the year
    func totalAmountForYearByCategory() -> [String: Double] {
        var totalAmountByCategory: [String: Double] = [:]
        
        let startDate = Date().startOfYear()
        let endDate = Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: startDate)!
        
        let fetchRequest: NSFetchRequest<Category> = NSFetchRequest<Category>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        
        do {
            let categories = try managedObjectContext.fetch(fetchRequest)
            for category in categories {
                if let amount = Double(category.amount ?? "0") {
                    totalAmountByCategory[category.category ?? ""] = (totalAmountByCategory[category.category ?? ""] ?? 0) + amount
                }
            }
            
            for (category, totalAmount) in totalAmountByCategory {
                print("Total amount for \(category) in the year: \(totalAmount)")
            }
            
            return totalAmountByCategory
        } catch {
            print("Error fetching categories: \(error)")
            return [:]
        }
    }


    
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
               let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]

               switch section {
               case SectionType.RecentExpenses.rawValue:
                   // This section will contain the button cell
                   let buttonSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
                   let item = NSCollectionLayoutItem(layoutSize: buttonSize)
                   item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 15)
                   let group = NSCollectionLayoutGroup.vertical(layoutSize: buttonSize, subitems: [item])

                   let section = NSCollectionLayoutSection(group: group)
                    section.boundarySupplementaryItems = supplementaryViews
                   // section.orthogonalScrollingBehavior = .continuous
                   return section
               case SectionType.Categories.rawValue:
                   let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                   item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 15, bottom: 10, trailing: 15)
                   let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), repeatingSubitem: item, count: 1)
                   let section = NSCollectionLayoutSection(group: group)
                   section.boundarySupplementaryItems = supplementaryViews
                   return section
                  
               default:
                   let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
                   item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 2)
                   let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), subitem: item, count: 1)

                   let section = NSCollectionLayoutSection(group: group)
                   return section
               }
           }
    private func totalBudget(for category: String) -> Double {
        var totalBudget: Double = 0.0
        
        for item in userAdded where item.category == category {
            if let amount = Double(item.amount) {
                totalBudget += amount
            }
        }
        return totalBudget
    }

}


extension BudgetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            // Return the number of items for section 0 (if applicable)
            // For example, if there are additional UI elements in section 0
            return 1
        case 1:
            return userAdded.count
        default:
            return 0
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath .section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as? ButtonCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: [
                createButton(title: "All", action: #selector(AlltypeButtonTapped)),
                createButton(title: "Weekly", action: #selector(weeklyButtonTapped)),
                createButton(title: "Monthly", action: #selector(monthlyButtonTapped)),
                createButton(title: "Yearly", action: #selector(yearlyButtonTapped)),
            ]) { selectedCategory in
                self.selectedCategory = selectedCategory
                self.updateUI()
               
               
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BudgetCollectionViewCell.identifer, for: indexPath) as? BudgetCollectionViewCell else {
                       return UICollectionViewCell()
                   }
                   let viewModel = userAdded[indexPath.row]
            let progress = calculateProgress(for: viewModel.category)
                    cell.configure(with: viewModel, progress: progress)
            subtractAmount(from: viewModel.category, amountToSubtract: Double(viewModel.amount) ?? 0.0, cell: cell)

                   return cell
            
            
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }

        switch sectionType {
        case .Categories:
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BudgetHeaderCollectionReusableView.identifier, for: indexPath) as? BudgetHeaderCollectionReusableView {
                header.configure(with: "Categories")
                return header
            } else {
                fatalError("Failed to dequeue the header view for 'Categories' section.")
            }

        case .RecentExpenses:
            let emptyView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EmptyHeader", for: indexPath)
            emptyView.frame.size.height = 0
            return emptyView
        }
    }


    
    
}


extension Date {
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    func endOfWeek(using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: DateComponents(day: 7), to: startOfWeek())!
    }

    func startOfMonth(using calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }

    func endOfMonth(using calendar: Calendar = .current) -> Date {
        let startOfNextMonth = calendar.date(byAdding: DateComponents(month: 1), to: startOfMonth())!
        return calendar.date(byAdding: DateComponents(day: -1), to: startOfNextMonth)!
    }
    
    func startOfYear(using calendar: Calendar = .current) -> Date {
            let components = calendar.dateComponents([.year], from: self)
            return calendar.date(from: components)!
        }
}

extension BudgetViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Begin batch updates for the UI
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // End batch updates for the UI
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    // Implement other delegate methods as needed
}





