import UIKit
import Charts
import CoreData


class StatisticsViewController: UIViewController {
    
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return StatisticsViewController.createSectionLayout(section: sectionIndex)
        
    })
    var selectedDuration: String?

    var selectedCategory: String?
    var selectedCategories: String?
    private var chartCell: ChartCollectionViewCell?
    private var buttonCell: ButtonCollectionViewCell?
    private var Cell: SectionButtonCollectionViewCell?
    private var sectionCell: SectionCollectionViewCell?
    private var cell: SavedCollectionViewCell?
    var expense: [ExpenseCategory] = []
    var userAddedItems: [UserExpenseItem] = []
    var AddedItems: [UserIncomeItem] = []
    
  
   
    
    private var yearlyCell: YearlyChartCollectionViewCell?

   
    lazy var managedObjectContext: NSManagedObjectContext = {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }()
    
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
  
    
    func subtractAmount(from category: String, amountToSubtract: Double, cell: SavedCollectionViewCell) {
        var totalAmountDouble: Double = 0.0
        
        // Calculate the updated total amount
        for expenseItem in userAddedItems where expenseItem.category == category {
            if let amount = Double(expenseItem.amount) {
                totalAmountDouble += amount
            }
        }
        
        // Subtract the amount to subtract
        totalAmountDouble -= amountToSubtract
        
        // Take the absolute value to ensure the value is positive
        totalAmountDouble = abs(totalAmountDouble)
        
        // Update the savedAmountLabel with the updated total amount
        cell.savedLabel.text = "₦" + String(format: "%.2f", totalAmountDouble)
        
        // Find the index path of the cell
        if let indexPath = collectionView.indexPath(for: cell) {
            // Reload only the cell at that index path
            collectionView.reloadItems(at: [indexPath])
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statistics"
        
        view.addSubview(collectionView)
   
        tabBarController?.tabBar.isHidden = false
                       // or adjust its appearance
      tabBarController?.tabBar.isTranslucent = false
         
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        collectionView.register(ChartCollectionViewCell.self, forCellWithReuseIdentifier: ChartCollectionViewCell.identifier)
      collectionView.register(SectionButtonCollectionViewCell.self, forCellWithReuseIdentifier: SectionButtonCollectionViewCell.identifier)
        collectionView.register(SectionCollectionViewCell.self, forCellWithReuseIdentifier: SectionCollectionViewCell.identifier)
        collectionView.register(SavedCollectionViewCell.self, forCellWithReuseIdentifier: SavedCollectionViewCell.identifier)
        let buttonCell = ButtonCollectionViewCell()
        buttonCell.configure(with: [
                    createButton(title: "Daily", action: #selector(AlltypeButtonTapped)),
                    createButton(title: "Weekly", action: #selector(recurringButtonTapped)),
                    createButton(title: "Monthly", action: #selector(groceryButtonTapped)),
                    createButton(title: "Yearly", action: #selector(foodButtonTapped)),
                   
                ]) { selectedCategory in
                    self.selectedCategory = selectedCategory
                   
                   
                    
                }
        
        let Cell = SectionButtonCollectionViewCell()
        Cell.configure(with: [  createButton(title: "Category", action: #selector(categoryButtonTapped)),
                                createButton(title: "Top Spending", action: #selector(spendingButtonTapped)),
                                createButton(title: "Top Incomes", action: #selector(incomeButtonTapped)),
                               
                             ]) { selectedCategories in
            self.selectedCategories = selectedCategories
            self.collectionView.reloadData()
        }
        
        //fetchUniqueCategories()
        //fetchUniqueIncomeCategories()
       
    }
    
 
    
 
    @objc private func categoryButtonTapped () {
        
        selectedCategories = "Category"
      fetchUniqueCategories()
       
       
       
       
        
    }
    @objc private func spendingButtonTapped () {
      
        
            selectedCategories = "Top Spending"
           fetchUniqueCategories()
           
      
            
            
           
        }
    


    
    @objc private func incomeButtonTapped () {
      
        selectedCategories = "Top Income"
        fetchUniqueIncomeCategories()
        
        
      
       
        
    }
    
    
    func fetchUniqueCategories() {
        let fetchRequestForCategories: NSFetchRequest<NSDictionary> = NSFetchRequest<NSDictionary>(entityName: "Expense")
        fetchRequestForCategories.resultType = .dictionaryResultType
        fetchRequestForCategories.returnsDistinctResults = true
        fetchRequestForCategories.propertiesToFetch = ["category"]
        
        do {
            let fetchedCategories = try managedObjectContext.fetch(fetchRequestForCategories)
            
            // Extract category names from the fetched dictionaries
            let categoryNames = fetchedCategories.compactMap { $0["category"] as? String }
            
            // Convert category names to ExpenseCategory objects
            categories = categoryNames.map { categoryName in
                ExpenseCategory(name: categoryName, icon: "defaultIcon") // You need to replace "defaultIcon" with the appropriate icon for each category
            }
            
            collectionView.reloadData()
           
            
        } catch {
            print("Error fetching categories: \(error)")
        }
    }
    
    func fetchUniqueIncomeCategories() {
        let fetchRequestForCategories: NSFetchRequest<NSDictionary> = NSFetchRequest<NSDictionary>(entityName: "Income")
        fetchRequestForCategories.resultType = .dictionaryResultType
        fetchRequestForCategories.returnsDistinctResults = true
        fetchRequestForCategories.propertiesToFetch = ["category"]
        
        do {
            let fetchedCategories = try managedObjectContext.fetch(fetchRequestForCategories)
            
            // Extract category names from the fetched dictionaries
            let categoryNames = fetchedCategories.compactMap { $0["category"] as? String }
            
            // Convert category names to ExpenseCategory objects
           incomeCategories = categoryNames.map { categoryName in
               IncomeCategory(name: categoryName, icon: "defaultIcon") // You need to replace "defaultIcon" with the appropriate icon for each category
            }
            
            collectionView.reloadData()
            
           
        } catch {
            print("Error fetching categories: \(error)")
        }
    }


    
    
    
 
    func updateChartData() {
        guard let selectedCategory = selectedCategory else {
            print("No selected category. Skipping chart update.")
            return
        }

        print("Updating chart for category: \(selectedCategory)")

        switch selectedCategory {
        case "Daily":
            print("Updating chart for Daily view")
            chartCell?.updateChartData(category: selectedCategory)
        case "Weekly":
            print("Updating chart for Weekly view")
            chartCell?.updateChartData(category: selectedCategory)
        case "Monthly":
            print("Updating chart for Monthly view")
            chartCell?.updateChartData(category: selectedCategory)
        case "Yearly":
            print("Updating chart for Yearly view")
            chartCell?.updateChartData(category: selectedCategory)
        default:
            print("Unknown category: \(selectedCategory). Skipping chart update.")
            break
        }
    }


    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
          collectionView.frame = view.bounds
        }
    
    @objc private func AlltypeButtonTapped () {
        print("Alltype button tapped")
        selectedCategory = "Daily"
        print("Selected category: \(selectedCategory ?? "nil")")
        updateChartData()
        collectionView.reloadData()
       
       
        
    }
    @objc private func recurringButtonTapped() {
       
           
            selectedCategory = "Weekly"
            updateChartData()
       
       
        collectionView.reloadData()
     
            
           
        
    }


    
    @objc private func groceryButtonTapped () {
        selectedCategory = "Monthly"
        updateChartData()
        collectionView.reloadData()
        
      
       
        
    }
    @objc private func foodButtonTapped () {
        selectedCategory = "Yearly"
        updateChartData()
        collectionView.reloadData()
        
    }
    
    var  categories: [ExpenseCategory] = []
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
    
    private func fetchTotalExpenseAmount(startDate: Date, endDate: Date) -> String {
        var totalExpense: Double = 0.0
        
        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest<Expense>(entityName: "Expense")
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", startDate as CVarArg, endDate as CVarArg)
        
        do {
            let expenses = try managedObjectContext.fetch(fetchRequest)
            for expense in expenses {
                if let amountString = expense.amount, let amount = Double(amountString) {
                    totalExpense += amount
                }
            }
        } catch {
            print("Error fetching expenses: \(error)")
        }
        
        let nairaAmount = "₦" + String(format: "%.2f", totalExpense) // Concatenate Naira sign with the amount
        return nairaAmount
    }
    
    private func fetchTotalBudgetAmount(startDate: Date, endDate: Date) -> Double {
        var totalBudget: Double = 0.0
        
        let fetchRequest: NSFetchRequest<Category> = NSFetchRequest<Category>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", startDate as CVarArg, endDate as CVarArg)
        
        do {
            let categories = try managedObjectContext.fetch(fetchRequest)
            for category in categories {
                if let amountString = category.amount, let amount = Double(amountString) {
                    totalBudget += amount
                }
            }
        } catch {
            print("Error fetching categories: \(error)")
        }
        
        return totalBudget
    }
    
    private func updateExpenseLabelForPeriod(startDate: Date, endDate: Date) -> (String, UIImage?) {
        // Fetch total expense
        let totalExpense = fetchTotalExpenseAmount(startDate: startDate, endDate: endDate)

        // Fetch total budget
        let totalBudget = fetchTotalBudgetAmount(startDate: startDate, endDate: endDate)

        // Calculate remaining budget
        let remainingBudget = totalBudget - Double(totalExpense.dropFirst(1))!

        // Calculate total saved amount for the period
        let savedAmount = totalBudget - remainingBudget

        // Determine the duration message based on the selected category
        var durationMessage = ""
        var imageName = ""
        switch selectedCategory {
        case "Weekly":
            durationMessage = "this week"
            imageName = "weeklyImage"
        case "Monthly":
            durationMessage = "this month"
            imageName = "monthlyImage"
        case "Yearly":
            durationMessage = "this year"
            imageName = "yearlyImage"
        default:
            durationMessage = "this period"
        }

        let image = UIImage(named: imageName)
        let savedLabelText = "You have saved ₦\(remainingBudget) for \(durationMessage)."
        return (savedLabelText, image)
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
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()

        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        button.setTitle(title, for: .normal)
        button.setTitleColor(.darkGray, for: .normal) // Set default color to black

        // Check if the button's title matches selectedCategory or selectedCategories
        if let selectedCategory = selectedCategory, title == selectedCategory {
            button.setTitleColor(.systemIndigo, for: .normal) // Set link color for selected button
           
        } else if let selectedCategories = selectedCategories, title == selectedCategories {
            button.setTitleColor(.systemIndigo, for: .normal) // Set link color for selected button
            
        } else {
          
        }

        button.addTarget(self, action: action, for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)

        return button
    }

    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
       
        switch section {
        case 0:
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return section
            
       
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
           
            return section

        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 15, bottom: 15, trailing: 15)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
           
            return section
            
        case 3:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
           
            return section
        case 4:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15) // Adjust the top inset as needed

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
extension StatisticsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            guard let selectedCategories = selectedCategories, !selectedCategories.isEmpty else {
                       return 0  // If no selected category, return 0 sections
                   }
                   
                   switch selectedCategories {
                   case "Category":
                       return categories.count
                   case "Top Spending":
                       // Return the count of top spending categories
                       return 1
                   case "Top Income":
                       // Return the count of top income categories
                       return incomeCategories.count
                   default:
                       return 0
                   }
        default:
           return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedCollectionViewCell.identifier, for: indexPath) as? SavedCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            var cellBackgroundColor: UIColor
            var imageViewBackgroundColor: UIColor
            
            switch selectedCategory {
            case "Daily":
                cellBackgroundColor = .blue
                imageViewBackgroundColor = .blue
            case "Weekly":
                cellBackgroundColor = .brown
                imageViewBackgroundColor = .clear
            case "Monthly":
                cellBackgroundColor = .systemIndigo
                imageViewBackgroundColor = .clear
            case "Yearly":
                cellBackgroundColor = .orange
                imageViewBackgroundColor = .orange
            default:
                cellBackgroundColor = .white
                imageViewBackgroundColor = .white
            }
            
            cell.backgroundColor = cellBackgroundColor
            cell.statisticsImage.backgroundColor = nil
            cell.statisticsImage.alpha = 0.8
           
                   
            cell.layer.shadowColor = UIColor.link.cgColor
            cell.layer.cornerRadius = 15
            cell.layer.shadowOffset = CGSize(width: -4, height: -4)
            cell.layer.borderColor = UIColor.white.cgColor
            
            let currentDate = Date()
            let calendar = Calendar.current
            
            // Calculate start and end dates based on the selected duration
            var startDate: Date
            var endDate: Date
            switch selectedCategory {
            case "Weekly":
                startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
                endDate = calendar.date(byAdding: .weekOfYear, value: 1, to: startDate)!
            case "Monthly":
                startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
                endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
            case "Yearly":
                startDate = calendar.date(from: calendar.dateComponents([.year], from: currentDate))!
                endDate = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startDate)!
            default:
                // Default to daily
                startDate = currentDate
                endDate = currentDate
            }
            
            // Update the expense label for the selected duration
            let (savedMessage, image) = updateExpenseLabelForPeriod(startDate: startDate, endDate: endDate)
            cell.savedLabel.text = savedMessage
            cell.statisticsImage.image = image
           
            
            
            return cell

            

        case 1:
                  guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as? ButtonCollectionViewCell else {
                      return UICollectionViewCell()
                  }
                  buttonCell = cell
                  cell.configure(with: [
                      createButton(title: "Daily", action: #selector(AlltypeButtonTapped)),
                      createButton(title: "Weekly", action: #selector(recurringButtonTapped)),
                      createButton(title: "Monthly", action: #selector(groceryButtonTapped)),
                      createButton(title: "Yearly", action: #selector(foodButtonTapped)),
                  ]) { selectedCategory in
                      self.selectedCategory = selectedCategory
                     // self.updateChartData()
                  }
                  return cell

              case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.identifier, for: indexPath) as? ChartCollectionViewCell else {
                  return UICollectionViewCell()
              }
              chartCell = cell
              cell.updateChartData(category: selectedCategory ?? "")
           
              return cell
        case 3:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionButtonCollectionViewCell.identifier, for: indexPath) as? SectionButtonCollectionViewCell else {
                return UICollectionViewCell()
            }
           Cell = cell
            cell.configure(with: [
                createButton(title: "Category", action: #selector(categoryButtonTapped)),
                createButton(title: "Top Spending", action: #selector(spendingButtonTapped)),
                createButton(title: "Top Income", action: #selector(incomeButtonTapped)),
              
            ]) { selectedCategories in
                self.selectedCategories = selectedCategories
                //self.updateSection()
              
            }
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCollectionViewCell.identifier, for: indexPath) as? SectionCollectionViewCell else {
                      return UICollectionViewCell()
                  }
                  sectionCell = cell
                  
                  if let selectedCategories = selectedCategories {
                      switch selectedCategories {
                      case "Category":
                          // Configure the cell with expense category data if available
                          if indexPath.row < categories.count {
                              let category = categories[indexPath.row]
                              cell.configure(with: category.name, totalAmount: fetchTotalAmountForCategory(categoryName: category.name))
                          }
                      case "Top Spending":
                          cell.selectedCategories = selectedCategories
                                    
                                    // Update UI based on the selected category
                            cell.updateSectionData(category: selectedCategories ?? "", indexPath: indexPath)
                                  
                      case "Top Income":
                          // Configure the cell with income category data if available
                          if indexPath.row < incomeCategories.count {
                              let category = incomeCategories[indexPath.row]
                              let incomeIconImageView = UIImageView()
                              cell.configureTopIncomeCell(with: category.name, totalAmount: fetchTotalAmountForIncome(categoryName: category.name))
                          }
                      default:
                          break
                      }
                  }
                  
                  return cell

           
        default:
            return UICollectionViewCell()
        }
    }
    
    
}
