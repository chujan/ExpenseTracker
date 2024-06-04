//
//  HomeViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 09/02/2024.
//

import UIKit
import PanModal
import CoreData
import FirebaseMessaging
import MessageUI
import UserNotifications

enum Sections: Int, CaseIterable {
    case Notify = 0
    case home = 1
    case Categories = 2
    case  Recentexpenses = 3
}



class HomeViewController: UIViewController, AddExpenseViewControllerDelegate, AddIncomeViewControllerDelegate, NSFetchedResultsControllerDelegate {
    
    var currentUser: User?
    var transactionsExist: Bool = false

   
    private var cell: NotificationCollectionViewCell?
 
    
    func didSaveIncomeItem(_ incomeItem: Income) {
        AddedItems.append(UserIncomeItem(income: incomeItem.income!, category: incomeItem.category!, itemName: incomeItem.source!, time: incomeItem.time!, date: incomeItem.date!, image: nil, categoryBackgroundColor: backgroundColor(for: incomeItem.category!)))
        updateIncomeUI()
        
        
    }
    var uniqueCategoriesSet: Set<String> = []
    var uniqueCategoriesArray = [String]()
    var newItemsCount: Int = 0

  
   
    var userAddedItems: [UserExpenseItem] = []
    var totalAmountForSection0: Double = 0.0
    var AddedItems: [UserIncomeItem] = []
    var fetchedResultsController: NSFetchedResultsController<Expense>?
    
    var fetchedResultController: NSFetchedResultsController<Income>?
    

    
    func didSaveExpenseItem(_ expenseItem: Expense) {
            // Handle the saved expense item here
            // For example, you can add it to your userAddedItems array and update the UI
        userAddedItems.append(UserExpenseItem(amount: expenseItem.amount!, category: expenseItem.category!, itemName: expenseItem.itemName!, time: expenseItem.time!, date: expenseItem.date!, image: nil, categoryBackgroundColor: backgroundColor(for: expenseItem.category!)))
        
        
        totalAmountForSection0 += Double(expenseItem.amount!) ?? 0.0
        
       
        fetchDataAndUpdateUI()

            // Print statement to confirm the item is passed
            print("Expense item passed to TransactionViewController: \(expenseItem)")
        }
    
    
    let addViewController = AddExpenseViewController()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }()
    
    var categories: [ExpenseCategory] = []
    
    
            
        
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return HomeViewController.createSectionLayout(section: sectionIndex)
        
    })

    override func viewDidLoad() {
        super.viewDidLoad()
       
      
        view.addSubview(collectionView)
        navigationController?.isNavigationBarHidden = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        setUpConstraints()
        tabBarController?.tabBar.tintColor = .systemIndigo
       
        updateIncomeUI()
        uniqueCategoriesSet = Set(categories.map { $0.name })
        view.backgroundColor = .systemBackground
        
        addViewController.delegate = self
       
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(MoneySpentCollectionViewCell.self, forCellWithReuseIdentifier: MoneySpentCollectionViewCell.identifier)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collectionView.register(CategoryheaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryheaderCollectionReusableView.identifier)
        collectionView.register(AddedCollectionViewCell.self, forCellWithReuseIdentifier: AddedCollectionViewCell.identifier)
        collectionView.register(NotificationCollectionViewCell.self, forCellWithReuseIdentifier: NotificationCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
     
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .userDataUpdated, object: nil)
               cell?.currentUser = currentUser
       
               
            
        
        view.backgroundColor = .systemBackground
        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest<Expense>(entityName: "Expense")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] // Adjust sorting as needed


           fetchedResultsController = NSFetchedResultsController(
               fetchRequest: fetchRequest,
               managedObjectContext: managedObjectContext,
               sectionNameKeyPath: nil,
               cacheName: nil
           )

        fetchedResultsController = NSFetchedResultsController(
               fetchRequest: fetchRequest,
               managedObjectContext: managedObjectContext,
               sectionNameKeyPath: nil,
               cacheName: nil
           )

           fetchedResultsController?.delegate = self

           do {
               try fetchedResultsController?.performFetch()
               fetchDataAndUpdateUI()
           } catch {
               print("Error fetching expenses: \(error)")
           }
        
        let incomeFetchRequest: NSFetchRequest<Income> = NSFetchRequest<Income>(entityName: "Income")
        incomeFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] // Adjust sorting as needed

        fetchedResultController = NSFetchedResultsController(
            fetchRequest: incomeFetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultController?.delegate = self

        do {
            try fetchedResultController?.performFetch()
            updateIncomeUI() // Call the method to update your UI with the new income data
        } catch {
            print("Error fetching income: \(error)")
        }

        
      
        

       
    }
   
    @objc private func reloadCollectionView() {
        self.collectionView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .userDataUpdated, object: nil)
    }
    
   
    func fetchUniqueCategories() {
            // Create a fetch request for Expense entities
            let fetchRequest: NSFetchRequest<NSDictionary> = NSFetchRequest<NSDictionary>(entityName: "Expense")

            // Set up the fetch request to fetch distinct values for the category attribute
            fetchRequest.resultType = .dictionaryResultType
            fetchRequest.returnsDistinctResults = true
            fetchRequest.propertiesToFetch = ["category"]

            do {
                // Perform the fetch request
                let result = try managedObjectContext.fetch(fetchRequest)

                // Extract the unique categories from the fetch result
                var uniqueCategories = Set<String>()
                var categoriesArray = [String]()

                for categoryDict in result {
                    if let category = categoryDict["category"] as? String {
                        if !uniqueCategories.contains(category) {
                            uniqueCategories.insert(category)
                            categoriesArray.append(category)
                        }
                    }
                }

                // Store unique categories in uniqueCategoriesArray
                uniqueCategoriesArray = categoriesArray

                // Now uniqueCategoriesArray contains unique categories
                print("Unique categories: \(uniqueCategoriesArray)")

                // Store or process the unique categories as needed

            } catch {
                print("Error fetching categories: \(error)")
            }
        }

    
    private func setUpConstraints() {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: -25),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    
    
    
    public func  navigateToAccountVC() {
        let vc = AccountViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
   
    public func navigateToItemList() {
        // Instantiate PanelViewController with the provided userAddedItems
        let itemListViewController = PanelViewController(userAddedItems: userAddedItems)
        
        // Present the PanelViewController modally
        presentPanModal(itemListViewController)
    }

    public func navigateToNotifyVC() {
        // Reset the badge count
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let vc = NotificationViewController(userAddedItems: userAddedItems)
        navigationController?.pushViewController(vc, animated: true)
    }


    
    func incrementBadgeCount() {
        let currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
        UIApplication.shared.applicationIconBadgeNumber = currentBadgeCount + 1
        newItemsCount += 1
        print("Badge count incremented to: \(currentBadgeCount + 1)")
    }
    

    public func navigateToAnotherItemList() {
        let itemListViewController = CategoryPanelViewController(userAddedItems: userAddedItems, categories: categories)
        presentPanModal(itemListViewController)
      
    }
    
  

    

    func totalAmount(for category: String) -> Double {
        let filteredItems = userAddedItems.filter { $0.category == category }
        let totalAmount = filteredItems.reduce(0.0) { $0 + (Double($1.amount) ?? 0.0) }
        return totalAmount
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if controller == fetchedResultsController {
                // Handle expense data changes
                fetchDataAndUpdateUI()
            } else if controller == fetchedResultController {
                // Handle income data changes
                updateIncomeUI()
            }

            
        }
    
    func updateIncomeUI() {
        guard let fetchedIncomeObjects = fetchedResultController?.fetchedObjects else {
            print("No fetched income objects found.")
            return
        }

        AddedItems = fetchedIncomeObjects.map { income in
            return UserIncomeItem(income: income.income!,
                                  category: income.category!,
                                  itemName: income.source!,
                                  time: income.time!,
                                  date: income.date!,
                                  image: nil,
                                  categoryBackgroundColor: backgroundColor(for: income.category!))
        }
        let totalIncome = calculateTotalIncome()
       
           print("Total Income: \(totalIncome)")

        // Additional logic for updating UI based on income data
        // ...

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    



    func updateCategoriesUI() {
        // Fetch unique categories directly from Core Data
        fetchUniqueCategoriesFromCoreData()

        // Reload the collection view data
        
    }


    
   
    
    func updateUserAddedItemsUI() {
        // Fetch user added items directly from Core Data
        let fetchedUserAddedItems = fetchUserAddedItemsFromCoreData()

        // Update the userAddedItems array
        self.userAddedItems = fetchedUserAddedItems

        // Reload the collection view data
      
    }
    func fetchUserAddedItemsFromCoreData() -> [UserExpenseItem] {
        guard let fetchedObjects = fetchedResultsController?.fetchedObjects else {
            print("No fetched objects found.")
            return []
        }

        var userAddedItems = [UserExpenseItem]()
        var newItemsCount = 0
        transactionsExist = !userAddedItems.isEmpty
          

        for expense in fetchedObjects {
            let userExpenseItem = UserExpenseItem(amount: expense.amount!,
                                                  category: expense.category!,
                                                  itemName: expense.itemName ?? "",
                                                  time: expense.time ?? "",
                                                  date: expense.date ?? Date(),
                                                  image: expense.image,
                                                  categoryBackgroundColor: backgroundColor(for: expense.category!))
            userAddedItems.append(userExpenseItem)
            newItemsCount += 1
        }

        // Increment badge count if new items are detected
        if newItemsCount > 0 {
            incrementBadgeCount()
        }

        return userAddedItems
    }

    func fetchUniqueCategoriesFromCoreData() {
        // Create a fetch request for Expense entities
        let fetchRequest: NSFetchRequest<NSDictionary> = NSFetchRequest<NSDictionary>(entityName: "Expense")

        // Set up the fetch request to fetch distinct values for the category attribute
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = ["category"]

        do {
            // Perform the fetch request
            let result = try managedObjectContext.fetch(fetchRequest)

            // Extract the unique categories from the fetch result
            var uniqueCategories = Set<String>()

            for categoryDict in result {
                if let category = categoryDict["category"] as? String {
                    uniqueCategories.insert(category)
                }
            }

            // Clear the existing categories array before updating
            categories.removeAll()

            // Map unique categories to ExpenseCategory objects
            categories = uniqueCategories.map { ExpenseCategory(name: $0, icon: iconForCategory($0)) }

            // Now categories array contains unique categories
            print("Updated categories: \(categories)")
        } catch {
            print("Error fetching categories: \(error)")
        }
    }

    
    func iconForCategory(_ category: String) -> String {
        switch category {
        case "Recurring":
            return "arrow.triangle.2.circlepath"
        case "Grocery":
            return "house"
        case "Food":
            return "fork.knife"
        case "Fuel":
            return "fuelpump"
        case "Online":
            return "globe"
        case "Shopping":
            return "bag"
        case "Net Banking":
            return "building.columns"
        case "Travels":
            return "airplane"
        case "Sport":
            return "figure.run"
        case "Kids":
            return "figure.and.child.holdinghands"
        case "Cinema":
            return "film"
        case "Gadgets":
            return "oven"
        default:
            return "defaultIcon"
        }
    }

    func fetchDataAndUpdateUI() {
        DispatchQueue.main.async {
            self.updateUserAddedItemsUI()
                 
            self.updateCategoriesUI()
            self.collectionView.reloadData()
            
        }
      
          
        
          

       
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                // Show notifications even when the app is in the foreground
                completionHandler([.alert, .sound, .badge])
            }

    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
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

        
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        switch section {
        case 0:
            
            let heightFraction: CGFloat = 1.0 // For example, you can set it to occupy 40% of the height
                    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(heightFraction)))
                    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15)
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), repeatingSubitem: item, count: 1)
                    let section = NSCollectionLayoutSection(group: group)
                    return section

            
        case 1:
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return section
        
       
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.7)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 8, trailing: 15) // Adjust the insets as needed
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitem: item, count: 4) // Adjust the count as needed
            let section = NSCollectionLayoutSection(group: group)
            
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 3:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section

            
            
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 2)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), repeatingSubitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
        }
    }
    
    

   
    

   
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
            
        case 2:
            let maxItemsToShowInCollectionViewCell = 8
                    return categories.isEmpty ? 1 : min(categories.count, maxItemsToShowInCollectionViewCell)
            
            
        case 3:
            let maxItemsToShowInCollectionViewCell = 3
                    return min(userAddedItems.count, maxItemsToShowInCollectionViewCell)
            
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCollectionViewCell.identifier, for: indexPath) as? NotificationCollectionViewCell else {
                return UICollectionViewCell()
            }
            self.cell = cell
            cell.updateBadge(count: newItemsCount)
            return cell
            
        case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoneySpentCollectionViewCell.identifier, for: indexPath) as? MoneySpentCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                let totalIncome = calculateTotalIncome()
                let totalExpense = calculateTotalExpenses()
                let totalBalance = calculateTotalIncome() - calculateTotalExpenses()
                let progressPercentage = (totalBalance / totalIncome) * 100
                
                // Ensure indexPath.item is within bounds of AddedItems array
                if indexPath.item < AddedItems.count {
                    let viewModel = AddedItems[indexPath.item]
                    cell.configure(progress: Int(progressPercentage), spentTitle: "Balance", ofTitle: "Income", totalIncome: totalIncome, totalExpense: totalExpense, expense: "Expense", remainingBalance: totalBalance)
                } else {
                    // Handle out-of-range condition gracefully, possibly by showing default content or an empty cell
                  print(" cell.configureDefault()") // Example method to configure a default cell state
                }
                
                return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                  

            if categories.isEmpty {
                           cell.configure(with: nil, hasCategories: false)
                       } else if indexPath.item < categories.count {
                           let category = categories[indexPath.item]
                           cell.configure(with: category, hasCategories: true)
                       }

                    return cell


            
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedCollectionViewCell.identifier, for: indexPath) as? AddedCollectionViewCell else {
                return UICollectionViewCell()
            }

            // Ensure that indexPath.row is a valid index for userAddedItems
            if indexPath.row < userAddedItems.count {
                let recents = userAddedItems[indexPath.row]
                cell.configure(with: recents)
            } else {
                // Handle the case where indexPath.row is out of bounds
                // You can choose to configure the cell differently or return a default cell
                // For now, let's print a message to help identify the issue
                print("Index out of bounds: indexPath.row = \(indexPath.row), userAddedItems count = \(userAddedItems.count)")
            }

            return cell

            
            
            
        default:
            return UICollectionViewCell()
        }
       
    
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }

        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let sectionEnum = Sections(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }

        switch sectionEnum {
        case .home, .Notify:
            // Configure home section header if needed
            break
        case .Categories:
            let categoryHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryheaderCollectionReusableView.identifier, for: indexPath) as? CategoryheaderCollectionReusableView
            categoryHeader?.configure(with: "Categories")
            return categoryHeader ?? UICollectionReusableView()
        case .Recentexpenses:
            header.configure(with: "Recent expenses")
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            break
        case 2:
            print("Selected section: \(indexPath.section)")
            print("Selected item: \(indexPath.item)")
            print("Total categories count: \(categories.count)")

            if indexPath.item < categories.count {
                let selectedCategory = categories[indexPath.item]
                navigateToCategoryDetail(category: selectedCategory)
            }

        default:
            break
        }
    }
    
    func navigateToCategoryDetail(category: ExpenseCategory) {
        // Filter the userAddedItems based on the selected category
        let itemsForCategory = userAddedItems.filter { $0.category == category.name }

        // Calculate the total amount for the selected category
        let totalAmountForCategory = totalAmount(for: category.name)

        // Create a new instance of AddedDetailsViewController with the filtered items
        let categoryDetailViewController = AddedDetailsViewController(userAddedItems: itemsForCategory)
        categoryDetailViewController.totalAmountForSection0 = totalAmountForCategory
        categoryDetailViewController.selectedCategory = category.name // Pass the selected category name
        
        // Pass the name of the selected category item
        //categoryDetailViewController.selectedItemName = category.name

        // Push the new view controller
        navigationController?.pushViewController(categoryDetailViewController, animated: true)

        // Set the title of HomeViewController to the selected category name
        
    }




    
}

extension Notification.Name {
    static let newUserExpenseItemAdded = Notification.Name("newUserExpenseItemAdded")
}

// Increment the app badge count
