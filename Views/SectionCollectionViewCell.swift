//
//  SectionCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 29/03/2024.
//



import UIKit
import CoreData


class SectionCollectionViewCell: UICollectionViewCell, NSFetchedResultsControllerDelegate, AddExpenseViewControllerDelegate, AddIncomeViewControllerDelegate {
    func didSaveIncomeItem(_ incomeItem: Income) {
        AddedItems.append(UserIncomeItem(income: incomeItem.income!, category: incomeItem.category!, itemName: incomeItem.source!, time: incomeItem.time!, date: incomeItem.date!, image: nil, categoryBackgroundColor: backgroundColors(for: incomeItem.category!)))
        updateIncomeUI()
        
    }
    
    func didSaveExpenseItem(_ expenseItem: Expense) {
        userAddedItems.append(UserExpenseItem(amount: expenseItem.amount!, category: expenseItem.category!, itemName: expenseItem.itemName!, time: expenseItem.time!, date: expenseItem.date!, image: nil, categoryBackgroundColor: backgroundColor(for: expenseItem.category!)))
        
        
       // totalAmountForSection0 += Double(expenseItem.amount!) ?? 0.0
        
       
            updateUIs()

            // Print statement to confirm the item is passed
            print("Expense item passed to TransactionViewController: \(expenseItem)")
    }
    var selectedCategories: String? {
           didSet {
               // Update UI based on the selected category whenever it changes
               updateUIs()
               updateIncomeUI()
               
           }
       }
    //var collectionView = UICollectionView()
    
    static let identifier = "SectionCollectionViewCell"
   

    var fetchedResultsController: NSFetchedResultsController<Expense>?
    
    var fetchedResultController: NSFetchedResultsController<Income>?
    
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
    
    
    var  incomeCategories: [IncomeCategory] = [
            IncomeCategory(name: "Salary", icon: "briefcase"),
            IncomeCategory(name: "FreeLance", icon: "laptopcomputer"),
            IncomeCategory(name: "Business", icon: "building.columns"),
            IncomeCategory(name: "Gift", icon: "gift"),
            IncomeCategory(name: "Alimony", icon: "figure.2.and.child.holdinghands"),
            IncomeCategory(name: "Dividend", icon: "chart.line.uptrend.xyaxis"),
            IncomeCategory(name: "Royalties", icon: "music.note"),
            IncomeCategory(name: "Rental", icon: "house"),
            IncomeCategory(name: "Grants", icon: "graduationcap"),
            IncomeCategory(name: "Bonuses", icon: "dollarsign"),
           
            
            ]
    var userAddedItems: [UserExpenseItem] = []
    var AddedItems: [UserIncomeItem] = []
    
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.cornerRadius = 5
       
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
     
        let reducedBlueColor = UIColor.systemBlue.withAlphaComponent(0.5)
        return imageView
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dashLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .red
        label.text = "-"
        label.font = .systemFont(ofSize: 25, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundViewContainer)
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(dashLabel)
        addSubview(amountLabel)
        setupContrsint()
        
        contentView.backgroundColor = .secondarySystemBackground
        
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
       
        //contentView.layer.borderColor = UIColor.white.cgColor
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
    
    func fetchTotalAmountForCategory(categoryName: String) -> String {
        var totalAmount: Double = 0.0
        
        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest<Expense>(entityName: "Expense")
        fetchRequest.predicate = NSPredicate(format: "category == %@", categoryName)
        
        do {
            let expenses = try managedObjectContext.fetch(fetchRequest)
            for expense in expenses {
                if let amountString = expense.amount, let amount = Double(amountString) {
                    totalAmount += amount
                }
            }
        } catch {
            print("Error fetching expenses for category \(categoryName): \(error)")
        }
        
        return "₦" + String(format: "%.2f", totalAmount)
    }
    
    
    func fetchTotalAmountForIncome(categoryName: String) -> String {
        var totalAmount: Double = 0.0
        
        let fetchRequest: NSFetchRequest<Income> = NSFetchRequest<Income>(entityName: "Income")
        fetchRequest.predicate = NSPredicate(format: "category == %@", categoryName)
        
        do {
            let expenses = try managedObjectContext.fetch(fetchRequest)
            for expense in expenses {
                if let amountString = expense.income, let amount = Double(amountString) {
                    totalAmount += amount
                }
            }
        } catch {
            print("Error fetching expenses for category \(categoryName): \(error)")
        }
        
        return "₦" + String(format: "%.2f", totalAmount)
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
                                  categoryBackgroundColor: backgroundColors(for: income.category!))
        }
        let uniqueCategories = Set(AddedItems.map { $0.category })

       incomeCategories = uniqueCategories.map { category in
            // Determine the icon dynamically based on the category name
            let icon: String
            
            switch category {
            case "Salary":
                icon = "briefcase.fill"
            case "FreeLance":
                icon = "laptopcomputer"
            case "Business":
                icon = "building.columns"
            case "Gift":
                icon = "gift"
            case "Alimony":
                icon = "figure.2.and.child.holdinghands"
            case "Dividend":
                icon = "chart.line.uptrend.xyaxis"
            case "Royalties":
                icon = "music.note"
            case "Rental":
                icon = "house"
            case "Grants":
                icon = "graduationcap"
            case "Bonuses":
                icon = "dollarsign"
            
            default:
                icon = "defaultIcon"
            }
         
            
            return IncomeCategory(name: category, icon: icon)
        }
        for (index, category) in incomeCategories.enumerated() {
               let total = totalIncomeAmount(for: category.name)
               print("Total income for \(category.name): \(total)")
               
               // Provide the appropriate index path for each category
               let indexPath = IndexPath(row: index, section: 4)
               updateSectionData(category: category.name, indexPath: indexPath)
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
            case "Gadgets":
                icon = "oven"
            default:
                icon = "defaultIcon"
            }

            return ExpenseCategory(name: category, icon: icon)
        }

        for (index, category) in categories.enumerated() {
               let total = totalAmount(for: category.name)
               print("Total amount for \(category.name): \(total)")
               
               // Provide the appropriate index path for each category
               let indexPath = IndexPath(row: index, section: 4)
               updateSectionData(category: category.name, indexPath: indexPath)
           }
    }
    
    private func totalAmount(for category: String) -> String {
        var totalAmount: Double = 0.0

        for expenseItem in userAddedItems where expenseItem.category == category {
            if let amount = Double(expenseItem.amount) {
                totalAmount += amount
            }
        }

        return "₦" + String(format: "%.2f", totalAmount)
    }
    
    private func totalIncomeAmount(for category: String) -> String {
        var totalAmount: Double = 0.0

        for expenseItem in AddedItems where expenseItem.category == category {
            if let amount = Double(expenseItem.income) {
                totalAmount += amount
            }
        }

        return "₦" + String(format: "%.2f", totalAmount)
    }
    
    func updateSectionData(category: String, indexPath: IndexPath) {
        switch category {
        case "Category":
          
            guard indexPath.row < categories.count else {
                       print("Index out of bounds: indexPath.row = \(indexPath.row), categories count = \(categories.count)")
                       return
                   }

                   // Update the UI based on fetched data
                   updateUIs()

                   let categoryName = categories[indexPath.row].name

                   // Fetch expenses for the specific category
                   let totalAmount = fetchTotalAmountForCategory(categoryName: categoryName)
                   configure(with: categoryName, totalAmount: totalAmount)
        case "Top Income":
                   // Configure "Top Income" section cell
                   guard indexPath.row < incomeCategories.count else {
                       print("Index out of bounds: indexPath.row = \(indexPath.row), incomeCategories count = \(incomeCategories.count)")
                       return
                   }

                   let categoryName = incomeCategories[indexPath.row].name

                   // Fetch income for the specific category
                   let totalAmount = fetchTotalAmountForIncome(categoryName: categoryName)
                   configureTopIncomeCell(with: categoryName, totalAmount: totalAmount)
                 
        case "Top Spending":
            if let topSpentCategory = findTopSpentCategory() {
                      // Configure UI with top spent category
                      configure(with: topSpentCategory.name, totalAmount: fetchTotalAmountForCategory(categoryName: topSpentCategory.name))
                  } else {
                      // Handle if no expenses found
                  }
        default:
            break
        }
    }
    
    func configureTopIncomeCell(with categoryName: String, totalAmount: String) {
        // Configure the cell UI with income category and total amount
        nameLabel.text = categoryName
        timeLabel.text = "" // Set the time associated with the category
        
        if let incomeCategory = incomeCategories.first(where: { $0.name == categoryName }) {
            // Fetch and configure income category
            iconImageView.image = UIImage(systemName: incomeCategory.icon!)
            amountLabel.text = totalAmount
            dashLabel.text  = "+"
            iconImageView.tintColor = .white
            let (iconImage, backgroundColor) = iconImageAndColor(for: incomeCategory.name)
            iconImageView.image = iconImage
            backgroundViewContainer.backgroundColor = backgroundColor
            amountLabel.textColor = .systemGreen
            dashLabel.textColor = .systemGreen
        } else {
            // Handle if category not found
            amountLabel.textColor = .systemGray // Set default color if category not found
        }
    }

    
    
    func findTopSpentCategory() -> ExpenseCategory? {
        var categoryAmounts = [String: Double]()
        
        // Calculate total spent for each category
        for expenseItem in userAddedItems {
            if let amount = Double(expenseItem.amount) {
                if let currentAmount = categoryAmounts[expenseItem.category] {
                    categoryAmounts[expenseItem.category] = currentAmount + amount
                } else {
                    categoryAmounts[expenseItem.category] = amount
                }
            }
        }
        
        // Find the category with the highest total spent
        let topSpentCategory = categoryAmounts.max { a, b in a.value < b.value }
        
        // Return the ExpenseCategory object corresponding to the top spent category
        if let categoryName = topSpentCategory?.key {
            return categories.first(where: { $0.name == categoryName })
        } else {
            return nil
        }
    }
    
    func backgroundColors(for category: String) -> UIColor {
        switch category {
        case "Salary":
            return UIColor.systemBlue
        case "Gift":
            return UIColor.systemGreen
        case "Business":
            return UIColor.systemOrange
        case "Rental":
            return UIColor.systemPurple
        // Add more cases as needed for other categories
        default:
            return UIColor.systemGray
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
    
    


    
    private func setupContrsint() {
        NSLayoutConstraint.activate([
            
            backgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
                        backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                        //backgroundViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                        backgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 50),
                       
           iconImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
                        iconImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
                       iconImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.7), // Adjust the multiplier
                        iconImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.7),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 10),
            dashLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dashLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -120),
            
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            amountLabel.leadingAnchor.constraint(equalTo: dashLabel.trailingAnchor)
            ])
    }
    
    func configure(with categoryName: String, totalAmount: String) {
        nameLabel.text = categoryName
        timeLabel.text = "" // Set the time associated with the category
        
        if let expenseCategory = categories.first(where: { $0.name == categoryName }) {
            iconImageView.image = UIImage(systemName: expenseCategory.icon!)
            amountLabel.text = totalAmount
            
            // Set fixed colors for categories
            backgroundViewContainer.backgroundColor = UIColor.systemGray4
            amountLabel.textColor = .red
            dashLabel.textColor = .red
            iconImageView.tintColor = .blue
            dashLabel.text = "-"
        } else {
            // Handle if category not found
        }
    }

    
}
extension SectionCollectionViewCell {
    func iconImageAndColor(for category: String) -> (UIImage?, UIColor) {
        switch category {
        case "Salary":
            return (UIImage(systemName: "briefcase"), UIColor.systemBlue)
        case "Gift":
            return (UIImage(systemName: "gift"), UIColor.systemRed)
        case "Business":
            return (UIImage(systemName: "building.columns"), UIColor.cyan)
        case "Rental":
            return (UIImage(systemName: "house"), UIColor.systemMint)
        case "Alimony":
            return (UIImage(systemName: "figure.2.and.child.holdinghands"), UIColor.systemBrown)
        case "Dividend":
            return (UIImage(systemName: "chart.line.uptrend.xyaxis"), UIColor.systemGreen)
        case "Royalties":
            return (UIImage(systemName: "music.note"), UIColor.systemIndigo)
      
        case "Grants":
            return (UIImage(systemName: "graduationcap"), UIColor.systemPurple)
      
        case "Bonuses":
            return (UIImage(systemName: "dollarsign"), UIColor.systemFill)
        case "FreeLance":
            return (UIImage(systemName: "laptopcomputer"), UIColor.systemYellow)
      
      
      
      
      
      
        default:
            return (UIImage(systemName: "questionmark"), UIColor.systemGray)
        }
    }
}
