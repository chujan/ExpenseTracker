//
//  TransactionViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 09/02/2024.
//

import UIKit

import CoreData
enum Section: Int, CaseIterable {
   
   
    case search = 0
    case button = 1
    case Today = 2
    case Yesterday = 3
}


class TransactionViewController: UIViewController, AddViewControllerDelegate, UISearchBarDelegate {
    
   
//    var isSearchActive: Bool {
//        return !searchController.searchBar.text!.isEmpty && searchController.isActive
//    }

    
    func didSaveExpenseItem(_ expenseItem: Expense) {
        // Handle the saved expense item here
        // For example, you can add it to your userAddedItems array and update the UI
        userAddedItems.append(UserExpenseItem(amount: expenseItem.amount!, category: expenseItem.category!, itemName: expenseItem.itemName!, time: expenseItem.time!, date: expenseItem.date!, image: nil, categoryBackgroundColor: backgroundColor(for: expenseItem.category!)))
        
        
        
        
        
        // updateUI()
        
        // Print statement to confirm the item is passed
        print("Expense item passed to TransactionViewController: \(expenseItem)")
    }
    
    
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return TransactionViewController.createSectionLayout(section: sectionIndex)
        
    })
    var userAddedItems: [UserExpenseItem] = []
    var  yesterdayItems: [UserExpenseItem] = []
    var todayItems: [UserExpenseItem] = []
    var filteredItems: [UserExpenseItem] = []

    
    var isFilterButtonTapped = false
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    var selectedCategory: String? {
           didSet {
               if selectedCategory == "All" {
                   updateUI()
               }
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

    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = false
                       // or adjust its appearance
      tabBarController?.tabBar.isTranslucent = false
         
       
        collectionView.register(TransactionButtonCollectionViewCell.self, forCellWithReuseIdentifier: TransactionButtonCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        collectionView.register(AddedCollectionViewCell.self, forCellWithReuseIdentifier: AddedCollectionViewCell.identifier)
        collectionView.register(TodayCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodayCollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        title = "Transactions"
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
       
        
        let buttonCell = TransactionButtonCollectionViewCell()
        buttonCell.configure(with: [
                    createButton(title: "All", action: #selector(AlltypeButtonTapped)),
                    createButton(title: "Recurring", action: #selector(recurringButtonTapped)),
                    createButton(title: "Grocery", action: #selector(groceryButtonTapped)),
                    createButton(title: "Food", action: #selector(foodButtonTapped)),
                    createButton(title: "Shopping", action: #selector(shoppingButtonTapped)),
                    createButton(title: "Gadgets", action: #selector(gadgetsButtonTapped)),
                    createButton(title: "Fuel", action: #selector(fuelButtonTapped)),
                    createButton(title: "Online", action: #selector(onlineButtonTapped)),
                    createButton(title: "Travels", action: #selector(travelsButtonTapped)),
                    createButton(title: "Sport", action: #selector(sportButtonTapped)),
                    createButton(title: "Kids", action: #selector(kidsButtonTapped)),
                    createButton(title: "Cinema", action: #selector(cinemaButtonTapped))
                ]) { selectedCategory in
                    self.selectedCategory = selectedCategory
                    self.updateUI()
                }
       
        
    }

    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
          collectionView.frame = view.bounds
        fetchBalance()
      
        }
   
   
    
    
        private func addTodayAndYesterdayItemsIfNeeded() {
            let currentDate = Date()
            let calendar = Calendar.current
    
            // Check if there are items for today or yesterday
            let todayItems = userAddedItems.filter { calendar.isDateInToday($0.date) }
            let yesterdayItems = userAddedItems.filter { calendar.isDateInYesterday($0.date) }
    
            // Remove existing "Today" and "Yesterday" items from the array
            userAddedItems.removeAll { item in
                calendar.isDateInToday(item.date) || calendar.isDateInYesterday(item.date)
            }
    
            // Insert "Today" and "Yesterday" items at the beginning of the array
            if !todayItems.isEmpty {
                userAddedItems.insert(UserExpenseItem(amount: "", category: "",  itemName: "Today", time: "", date: currentDate, image: nil, categoryBackgroundColor: .clear), at: 0)
            }
            if !yesterdayItems.isEmpty {
             userAddedItems.insert(UserExpenseItem(amount: "", category: "",  itemName: "Yesterday", time: "", date: currentDate.addingTimeInterval(-86400), image: nil, categoryBackgroundColor: .clear), at: 0)
            }
        }

  
    
    private func updateUIForAllItems() {
        // Fetch all expenses from Core Data without filtering by category
        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest(entityName: "Expense")
        
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

    
   
   
    @objc private func AlltypeButtonTapped () {
        selectedCategory = "All"
       updateUI()
       
        
    }
    @objc private func recurringButtonTapped() {
        if let category = selectedCategory {
           
            selectedCategory = "Recurring"
            
            updateUI()
        }
    }


    
    @objc private func groceryButtonTapped () {
        selectedCategory = "Grocery"
        updateUI()
       
        
    }
    
    @objc private func foodButtonTapped () {
        selectedCategory = "Food"
      
        updateUI()
        
    }
    
    @objc private func gadgetsButtonTapped () {
        selectedCategory = "Gadgets"
      
        updateUI()
        
    }
    
    @objc private func fuelButtonTapped () {
        selectedCategory = "Fuel"
      
        updateUI()
        
    }
    
    @objc private func travelsButtonTapped () {
        selectedCategory = "Online"
      
        updateUI()
        
    }
    
    @objc private func sportButtonTapped () {
        selectedCategory = "Sport"
      
        updateUI()
        
    }
    
    @objc private func kidsButtonTapped () {
        selectedCategory = "Kids"
      
        updateUI()
        
    }
    
    @objc private func cinemaButtonTapped () {
        selectedCategory = "Cinema"
      
        updateUI()
        
    }
    
    @objc private func onlineButtonTapped () {
        selectedCategory = "Online"
      
        updateUI()
        
    }
    
    
    @objc private func shoppingButtonTapped() {
        if let category = selectedCategory {
            print("Before update - Shopping Button Tapped - Selected Category: \(category)")
            selectedCategory = "Shopping"
            
            print("After update - Shopping Button Tapped - Selected Category: \(selectedCategory ?? "nil")")
            updateUI()
        }
    }
    




    private func updateUIForSelectedCategory() {
            let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest(entityName: "Expense")

            if let selectedCategory = selectedCategory, selectedCategory != "All" {
                fetchRequest.predicate = NSPredicate(format: "category == %@", selectedCategory)
            }

            do {
                let expenses = try managedObjectContext.fetch(fetchRequest)
                userAddedItems = expenses.map { expense in
                    return UserExpenseItem(amount: expense.amount!,
                                           category: expense.category!,
                                           itemName: expense.itemName ?? "",
                                           time: expense.time ?? "",
                                           date: expense.date ?? Date(),
                                           image: expense.image,
                                           categoryBackgroundColor: backgroundColor(for: expense.category!))
                }
                collectionView.reloadData()
            } catch {
                print("Error fetching expenses: \(error)")
            }
        }

    
    private func updateUI() {
        // Fetch all expenses from Core Data
        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest(entityName: "Expense")
        
        // If a specific category is selected, filter expenses by category
        if let selectedCategory = selectedCategory, selectedCategory != "All" {
            fetchRequest.predicate = NSPredicate(format: "category == %@", selectedCategory)
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


    private func updateHeaderView(_ header: TodayCollectionReusableView, forSection section: Int) {
        let currentDate = Date()
        addTodayAndYesterdayItemsIfNeeded()

        // Fetch today's items
        let todayItems = userAddedItems.filter { Calendar.current.isDateInToday($0.date) }

        // Update the header view with "Today" items
        header.configure(todayItems: todayItems, yesterdayItems: [])
    }


    
    func calculateDayOfWeek(for date: Date, section: Int, item: Int) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE"  // This will give you abbreviated day names (e.g., "Mon", "Tue")
            let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            let index = (item + Calendar.current.firstWeekday - 1) % 7
            return daysOfWeek[index]
        }
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        switch section {
       
           

      
      
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(1.0))
                       )
                       item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 10)
            
                       
                       
                       let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), repeatingSubitem: item, count: 1)
                       
                       
                       
                       let section = NSCollectionLayoutSection(group: group)
                     
                       
                       
                       
                       return section
            
        case 1:
           
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .fractionalHeight(1.0))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    // Add spacing between items
                    item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)

                    // Group configuration
                    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(50))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                    // Section configuration
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous // Enable horizontal scrolling

                    return section
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 15, bottom: 0, trailing: 15)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
          
            return section
        case 3:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 15, bottom: 0, trailing: 15)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
          
            return section

            
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), repeatingSubitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
            
        }
        
        
        
    }
    func deleteExpenseItem(_ item: UserExpenseItem, at indexPath: IndexPath) {
        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest(entityName: "Expense")

        // Assuming `itemName` and `date` together uniquely identify an expense item
        fetchRequest.predicate = NSPredicate(format: "itemName == %@ AND date == %@", item.itemName, item.date as CVarArg)

        do {
            let expenses = try managedObjectContext.fetch(fetchRequest)
            for expense in expenses {
                // Use the objectID to uniquely identify and delete the object
                let objectID = expense.objectID
                let objectToDelete = try managedObjectContext.existingObject(with: objectID)
                managedObjectContext.delete(objectToDelete)
            }

            try managedObjectContext.save() // Save the context after deletion

            // Remove the item from the data source
            userAddedItems.remove(at: indexPath.item)

            // Update the collection view
            collectionView.deleteItems(at: [indexPath])

        } catch {
            print("Error deleting expense item: \(error)")
        }
    }
    public func navigateToItemList() {
        let itemListViewController = SearchViewController()
        presentPanModal(itemListViewController)
        
    }
    
    
   
    func fetchBalance() {
        // Define the endpoint URL including the API key as a query parameter
        let apiKey = "sk_test_oBS5si1jmXovSvp9cPfZ3c1w9WRresHLE7mggVkx"
        guard var components = URLComponents(string: "https://api.korapay.com/merchant/api/v1/balances") else {
            print("Invalid URL")
            return
        }
        components.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let apiUrl = components.url else {
            print("Invalid URL with query parameters")
            return
        }

        // Create the request object
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        // Create URLSession task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                return
            }

            // Check if there is data
            guard let data = data else {
                print("No data received")
                return
            }

            // Try to parse the JSON response
            do {
                // Assuming the response is JSON
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Check status
                    if let status = json["status"] as? Int, status == 1 {
                        // Authorized, print balance data
                        if let balanceData = json["data"] {
                            print("Balance Data: \(balanceData)")
                        } else {
                            print("No balance data found.")
                        }
                    } else {
                        // Unauthorized or other error
                        let message = json["message"] as? String ?? "Unknown error occurred."
                        print("Error: \(message)")
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }

        // Start the URLSession task
        task.resume()
    }

}

extension TransactionViewController: UICollectionViewDelegate, UICollectionViewDataSource, AddedCollectionViewCellDelegate {
    func deleteButtonTapped(_ cell: AddedCollectionViewCell) {
            guard let indexPath = collectionView.indexPath(for: cell) else {
                return
            }

            // Check if indexPath.item is within the valid range of userAddedItems
            if indexPath.item < userAddedItems.count {
                let item = userAddedItems[indexPath.item]

                // Show an alert to confirm deletion
                let alertController = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                    // Call the method to delete the item from Core Data
                    self.deleteExpenseItem(item, at: indexPath)
                }

                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)

                present(alertController, animated: true, completion: nil)
            }
        }

   
    
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
                let todayItemsCount = userAddedItems.filter { Calendar.current.isDateInToday($0.date) }.count
                return todayItemsCount
            case 3:
                let yesterdayItemsCount = userAddedItems.filter { Calendar.current.isDateInYesterday($0.date) }.count
                return yesterdayItemsCount
            default:
                return 0
            }
        }
    
    
        
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
            switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
                    return UICollectionViewCell()
                }
                let searchBar = cell.searchBar
                    let button = cell.button
                   cell.delegate = self
                    
                    // Customize the search bar and button if needed
                    searchBar.placeholder = "Search"
               
                    return cell
            case 1:
                guard let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionButtonCollectionViewCell.identifier, for: indexPath) as? TransactionButtonCollectionViewCell else {
                    return UICollectionViewCell()
                }
                buttonCell.configure(with: [
                    createButton(title: "All", action: #selector(AlltypeButtonTapped)),
                    createButton(title: "Recurring", action: #selector(recurringButtonTapped)),
                    createButton(title: "Grocery", action: #selector(groceryButtonTapped)),
                    createButton(title: "Food", action: #selector(foodButtonTapped)),
                    createButton(title: "Shopping", action: #selector(shoppingButtonTapped)),
                    createButton(title: "Gadgets", action: #selector(gadgetsButtonTapped)),
                    createButton(title: "Fuel", action: #selector(fuelButtonTapped)),
                    createButton(title: "Online", action: #selector(onlineButtonTapped)),
                    createButton(title: "Travels", action: #selector(travelsButtonTapped)),
                    createButton(title: "Sport", action: #selector(sportButtonTapped)),
                    createButton(title: "Kids", action: #selector(kidsButtonTapped)),
                    createButton(title: "Cinema", action: #selector(cinemaButtonTapped))
                ]) { selectedCategory in
                    self.selectedCategory = selectedCategory
                    self.updateUI()
                    
                }
                
                return buttonCell
            case 2:
                    // Today's items
                    let todayItems = userAddedItems.filter { Calendar.current.isDateInToday($0.date) }
                print("Today's items: \(todayItems)")
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedCollectionViewCell.identifier, for: indexPath) as? AddedCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    if indexPath.item < todayItems.count {
                        let item = todayItems[indexPath.item]
                        print("Configuring cell with today's item: \(item)")
                        cell.configure(with: item)
                        cell.delegate = self
                    }
                    return cell
                case 3:
                    // Yesterday's items
                    let yesterdayItems = userAddedItems.filter { Calendar.current.isDateInYesterday($0.date) }
                print("Yesterday's items: \(yesterdayItems)")
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedCollectionViewCell.identifier, for: indexPath) as? AddedCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    if indexPath.item < yesterdayItems.count {
                        let item = yesterdayItems[indexPath.item]
                        print("Configuring cell with yesterday's item: \(item)")
                        cell.configure(with: item)
                        cell.delegate = self
                    }
                    return cell
            default:
                return UICollectionViewCell()
            }
        }
    
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard let sectionEnum = Section(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }
    
            switch sectionEnum {
            case   .search, .button:
                return UICollectionReusableView()
    
            case .Today, .Yesterday:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: TodayCollectionReusableView.identifier,
                    for: indexPath
                ) as? TodayCollectionReusableView else {
                    return UICollectionReusableView()
                }
    
                if sectionEnum == .Today {
                    updateHeaderView(header, forSection: indexPath.section)
                } else if sectionEnum == .Yesterday {
                    updateYesterdayHeaderView(header, forSection: indexPath.section)
                }
    
                return header
            }
        }
    
        private func updateYesterdayHeaderView(_ header: TodayCollectionReusableView, forSection section: Int) {
                let currentDate = Date()
                addTodayAndYesterdayItemsIfNeeded()
    
                // Fetch yesterday's items
            let yesterdayItems = userAddedItems.filter { Calendar.current.isDateInYesterday($0.date) }
    
                // Update the header view with "Yesterday" items
                header.configure(todayItems: [], yesterdayItems: yesterdayItems)
            }
    
        
    
        }


//extension TransactionViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let searchText = searchController.searchBar.text else {
//            return
//        }
//        
//        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest(entityName: "Expense")
//        fetchRequest.predicate = NSPredicate(format: "category CONTAINS[cd] %@", searchText)
//        
//        do {
//            let expenses = try managedObjectContext.fetch(fetchRequest)
//            
//            // Print all categories being returned
//            let categories = expenses.map { $0.category ?? "" }
//            print("Categories: \(categories)")
//            
//            // Convert fetched expenses to UserExpenseItem objects
//           userAddedItems = expenses.map { expense in
//                return UserExpenseItem(amount: expense.amount ?? "",
//                                       category: expense.category ?? "",
//                                       itemName: expense.itemName ?? "",
//                                       time: expense.time ?? "",
//                                       date: expense.date ?? Date(),
//                                       image: expense.image,
//                                       categoryBackgroundColor: backgroundColor(for: expense.category ?? ""))
//            }
//            
//            collectionView.reloadData()
//        } catch {
//            print("Error fetching expenses: \(error)")
//        }
//    }
//}
extension TransactionViewController: CustomCollectionViewCellDelegate {
    func searchBarDidChange(text: String?) {
                let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest(entityName: "Expense")
        fetchRequest.predicate = NSPredicate(format: "category CONTAINS[cd] %@", text!)
        
                do {
                    let expenses = try managedObjectContext.fetch(fetchRequest)
        
                    // Print all categories being returned
                    let categories = expenses.map { $0.category ?? "" }
                    print("Categories: \(categories)")
        
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
        
                    collectionView.reloadData()
                } catch {
                    print("Error fetching expenses: \(error)")
                }
    }
    
}
