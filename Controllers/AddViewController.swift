//
//  AddViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 09/02/2024.
//

import UIKit
import CoreData

protocol AddViewControllerDelegate: AnyObject {
    func didSaveExpenseItem(_ expenseItem: Expense)
}

@objc(Expense)
public class Expense: NSManagedObject {
    @NSManaged public var amount: String?
       @NSManaged public var category: String?
       @NSManaged public var itemName: String?
       @NSManaged public var time: String?
       @NSManaged public var date: Date?
    @NSManaged public var image: UIImage?
    func setImageData(_ imageData: Data) {
           self.image = UIImage(data: imageData)
       }
}
class ExpenseEntryTableViewCell: UITableViewCell, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // Customize the format as needed
        return formatter
    }()

    var currentTime: Date = Date() {
           didSet {
               timePicker.date = currentTime
               
           }
       }
    
    var expenseEntity: Expense?
    weak var delegate: AddViewControllerDelegate?
    var selectedCategories: [String] = []
    var updateTransactionItems: (([UserExpenseItem]) -> Void)?
    var userAddedItems: [UserExpenseItem] = [] {
           didSet {
               updateUI()
           }
       }
    
   
    lazy var managedObjectContext: NSManagedObjectContext = {
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           return appDelegate.persistentContainer.viewContext
       }()
    
   

   
    
    var updateUI: (() -> Void) = {}
    
    lazy var timePicker: UIDatePicker = {
           let picker = UIDatePicker()
           picker.datePickerMode = .time
           picker.locale = Locale.current
           picker.date = currentTime // Set the initial time to the current time
           picker.translatesAutoresizingMaskIntoConstraints = false
           picker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
           return picker
       }()
    
    @objc private func timePickerValueChanged() {
           currentTime = timePicker.date
       }

      
    
    lazy var startButton: UIButton = {
            let button = UIButton()
            button.isUserInteractionEnabled = true
            button.isEnabled = true
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.white.cgColor
           // button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .link
            button.setTitle("Add expense", for: .normal)

            //button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
   
    var currentDate: Date = Date() {
            didSet {
                datePicker.date = currentDate
                updateDateTextField()
            }
        }
    static let identifier = "ExpenseEntryTableViewCell"
    let amountTextField = UITextField()
    let categoryTextField = UITextField()
    let itemTextField = UITextField()
    
    
    let dateTextField = UITextField()
    
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale.current
        picker.date = currentDate // Set the initial date to the current date
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    @objc private func datePickerValueChanged() {
        currentDate = datePicker.date
    }
    private func updateDateTextField() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" // You can adjust the date format as needed
        dateTextField.text = dateFormatter.string(from: currentDate)
    }
    
   
    
   
    func resetTextFields() {
        amountTextField.text = ""
        categoryTextField.text = ""
        itemTextField.text = ""
      
    }
    
    
    @objc private func startButtonTapped() {
      
       
        let selectedCategory = selectedCategories.first ?? ""
        let time = timeFormatter.string(from: currentTime)
            
        let amount = amountTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        let item = itemTextField.text ?? ""
       // let time = timePicker.textInputMode?.primaryLanguage ?? ""

        let date = currentDate

        // Validate and save the data
        if !amount.isEmpty, !category.isEmpty, !item.isEmpty, !time.isEmpty {
            
            if let expenseEntity = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: managedObjectContext) as? Expense {
                expenseEntity.amount = amount
                expenseEntity.category = category
                expenseEntity.itemName = item
                expenseEntity.time = time
                expenseEntity.date = date

                // Save the managed object context
                do {
                    try managedObjectContext.save()

                    // Check if the item has been saved
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
                    fetchRequest.predicate = NSPredicate(format: "amount == %@ AND category == %@ AND itemName == %@ AND time == %@ AND date == %@", amount, category, item, time, date as CVarArg)

                    if let results = try managedObjectContext.fetch(fetchRequest) as? [Expense], let savedItem = results.first {
                        // Item has been saved
                        print("Item saved with ID: \(savedItem.objectID)")
                        delegate?.didSaveExpenseItem(savedItem)
                    } else {
                        print("Error: Item not saved")
                    }

                    // Update the userAddedItems array directly
                    userAddedItems.append(UserExpenseItem(amount: amount, category: category, itemName: item, time: time, date: date, image: nil, categoryBackgroundColor: backgroundColor(for: category)))
                    updateTransactionItems?(userAddedItems)
                    
                   

                    // Update the UI
                    updateUI()
                    showSuccessAlert()

                    // Optional: Clear the text fields after adding the item
                    amountTextField.text = ""
                    categoryTextField.text = ""
                    itemTextField.text = ""
                   
                    dateTextField.text = ""

                    // Dismiss the keyboard and hide the text fields
                    amountTextField.resignFirstResponder()
                    categoryTextField.resignFirstResponder()
                    itemTextField.resignFirstResponder()
                  
                    dateTextField.resignFirstResponder()
                } catch {
                    print("Error saving expense entity: \(error)")
                }
            } else {
                print("Error creating Expense entity")
            }
        } else {
            // Handle invalid input or show an error message
            print("Invalid input. Please fill in all fields.")
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
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "₦"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.sizeToFit()
        return label
    }()
    
    private func formatDateString(_ date: Date) -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    
    private let amountPlaceholderLabel: UILabel = {
            let label = UILabel()
        label.text = "Amount"
            label.textColor = UIColor.placeholderText
            label.font = UIFont.systemFont(ofSize: 17)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private let catgoryPlaceholderLabel: UILabel = {
            let label = UILabel()
        label.text = "Category"
            label.textColor = UIColor.placeholderText
            label.font = UIFont.systemFont(ofSize: 17)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        private let timePlaceholderLabel: UILabel = {
            let label = UILabel()
            label.text = "Time"
            label.textColor = UIColor.placeholderText
            label.font = UIFont.systemFont(ofSize: 17)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private let ItemPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Item"
        label.textColor = UIColor.placeholderText
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        private let datePlaceholderLabel: UILabel = {
            let label = UILabel()
            label.text = "Date"
            
            label.textColor = UIColor.placeholderText
            label.font = UIFont.systemFont(ofSize: 17)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    

    
    


    private func showSuccessAlert() {
        // Find the topmost view controller
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            let alertController = UIAlertController(
                title: "Success",
                message: "Item added successfully!",
                preferredStyle: .alert
            )

            let okAction = UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            )

            alertController.addAction(okAction)

            // Present the alert on the topmost view controller
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }





    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        timePicker.datePickerMode = .time
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.delegate = self
               categoryTextField.delegate = self
               itemTextField.delegate = self
              
               dateTextField.delegate = self
        amountTextField.returnKeyType = .done
              categoryTextField.returnKeyType = .done
              itemTextField.returnKeyType = .done
              dateTextField.returnKeyType = .done
        
  
        // Customize the cell with necessary UI elements
        amountTextField.placeholder = ""
        categoryTextField.placeholder = ""
        itemTextField.placeholder = ""
       
        dateTextField.placeholder = ""
        
        dateTextField.inputView = datePicker
        datePicker.date = Date()
        
        amountTextField.clearsOnBeginEditing = false
           categoryTextField.clearsOnBeginEditing = false
           itemTextField.clearsOnBeginEditing = false
          
           dateTextField.clearsOnBeginEditing = false
        
        amountTextField.contentVerticalAlignment = .bottom
        categoryTextField.contentVerticalAlignment = .bottom
        itemTextField.contentVerticalAlignment = .bottom
      
        dateTextField.contentVerticalAlignment = .bottom


        
        let toolbar = UIToolbar()
                toolbar.barStyle = .default
                toolbar.isTranslucent = true
                toolbar.sizeToFit()
        
       
               dateTextField.inputAccessoryView = toolbar
        
                     

        // Add the input fields to the cell's contentView
        contentView.addSubview(amountTextField)
        contentView.addSubview(categoryTextField)
        contentView.addSubview(itemTextField)
      
        contentView.addSubview(dateTextField)
        //contentView.addSubview(startButton)
        amountTextField.addSubview(currencyLabel)
        contentView.addSubview(amountPlaceholderLabel)
        contentView.addSubview(catgoryPlaceholderLabel)
        contentView.addSubview(timePlaceholderLabel)
        contentView.addSubview(ItemPlaceholderLabel)
        contentView.addSubview(datePlaceholderLabel)
        contentView.addSubview(timePicker)
       
        
        contentView.backgroundColor = .systemBackground

        // Set up constraints
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

    private func setupConstraints() {
        updateDateTextField()
        [amountTextField, categoryTextField, itemTextField,  dateTextField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Add constraints for the text fields
        NSLayoutConstraint.activate([
            amountPlaceholderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            amountPlaceholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
           amountPlaceholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            currencyLabel.topAnchor.constraint(equalTo: amountTextField.topAnchor, constant: 40),
           currencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            
            amountTextField.topAnchor.constraint(equalTo: amountPlaceholderLabel.topAnchor, constant: -10),
            amountTextField.leadingAnchor.constraint(equalTo: currencyLabel.leadingAnchor, constant: 10),
            amountTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountTextField.heightAnchor.constraint(equalToConstant: 60),
            
            catgoryPlaceholderLabel.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
           catgoryPlaceholderLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor,constant:-16),
           catgoryPlaceholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:16),
            catgoryPlaceholderLabel.heightAnchor.constraint(equalToConstant: 30),
            
            categoryTextField.topAnchor.constraint(equalTo: catgoryPlaceholderLabel.bottomAnchor,constant:8),
            categoryTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ItemPlaceholderLabel.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 16),
            ItemPlaceholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
           ItemPlaceholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:16),
            ItemPlaceholderLabel.heightAnchor.constraint(equalToConstant: 30),
            
            itemTextField.topAnchor.constraint(equalTo: ItemPlaceholderLabel.bottomAnchor, constant: 8),
            itemTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
           timePlaceholderLabel.topAnchor.constraint(equalTo: itemTextField.bottomAnchor, constant: 16),
            timePlaceholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
           timePlaceholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:16),
            timePlaceholderLabel.heightAnchor.constraint(equalToConstant: 30),

            timePicker.topAnchor.constraint(equalTo: timePlaceholderLabel.bottomAnchor, constant: 8),
            timePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
           
            
          
            
            datePlaceholderLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 16),
             datePlaceholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            datePlaceholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:16),
             datePlaceholderLabel.heightAnchor.constraint(equalToConstant: 30),

            
            dateTextField.topAnchor.constraint(equalTo: datePlaceholderLabel.bottomAnchor, constant: 8),
            dateTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
         
            //startButton.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 30),
           // startButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
          //  startButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -240),
         //  startButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
         //   startButton.widthAnchor.constraint(equalToConstant: 30),
    
         //   startButton.heightAnchor.constraint(equalToConstant: 40),
            
         
           
        ])

        // Add separator lines
        let separator1 = createSeparator()
        let separator2 = createSeparator()
        let separator3 = createSeparator()
        let seperator4 = createSeparator()
        let seperator5 = createSeparator()

        contentView.addSubview(separator1)
        contentView.addSubview(separator2)
        contentView.addSubview(separator3)
        contentView.addSubview(seperator4)
        contentView.addSubview(seperator5)

        NSLayoutConstraint.activate([
            separator1.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 8),
            separator1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator1.heightAnchor.constraint(equalToConstant: 1),

            separator2.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 8),
            separator2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator2.heightAnchor.constraint(equalToConstant: 1),

            separator3.topAnchor.constraint(equalTo: itemTextField.bottomAnchor, constant: 8),
            separator3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator3.heightAnchor.constraint(equalToConstant: 1),
            
              seperator4.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 8),
             seperator4.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            seperator4.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            seperator4.heightAnchor.constraint(equalToConstant: 1),
            
            seperator5.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 8),
          seperator5.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
          seperator5.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
         seperator5.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
    
   

}







class AddViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: AddViewControllerDelegate?
    var userAddedItems: [UserExpenseItem] = []
    var yesterdayItems: [UserExpenseItem] = []
    var todayItems: [UserExpenseItem] = []

    var updateTransactionItems: (([UserExpenseItem]) -> Void)?
    var selectedCategory: String?

   
    
    let cell = "ExpenseEntryTableViewCell"
    
//    func updateUI() {
//        // Implement the logic to update the UI with the latest data
//        // For example, you might reload the table view or update specific UI elements.
//        tableView.reloadData()
//    }
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
   
    func updateDataSource() {
        userAddedItems.sort { $0.date > $1.date }
       
        
        tableView.reloadData()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        updateDataSource()
        view.backgroundColor = .systemBackground
       
        tableView.separatorStyle = .none
        
        
        tableView.register(ExpenseEntryTableViewCell.self, forCellReuseIdentifier: ExpenseEntryTableViewCell.identifier)
        
        
    }
    
  
   
       
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath) as! ExpenseEntryTableViewCell
        //cell.selectedCategories = ["Shopping", "Food", "All", "Recurring", "Grocery"]
       // cell.updateTransactionItems = { [weak self] items in
            // Update the items in AddViewController
           // self?.userAddedItems = items
            
            // Call the updateTransactionItems closure to update TransactionViewController
            //self?.updateTransactionItems?(items)
        //}
        return cell
    }
    
//    func setCategory(_ category: String) {
//          selectedCategory = category
//      }
    
    func didSaveExpenseItem(_ expenseItem: Expense) {
        // Handle the saved expense item if needed
        print("Expense item saved: \(expenseItem)")

        // Update userAddedItems and yesterdayItems with the new item
        let userExpenseItem = UserExpenseItem(amount: expenseItem.amount!,
                                              category: expenseItem.category!,
                                              itemName: expenseItem.itemName!,
                                              time: expenseItem.time!,
                                              date: expenseItem.date!,
                                              image: expenseItem.image,
                                              categoryBackgroundColor: backgroundColor(for: expenseItem.category!))

        userAddedItems.append(userExpenseItem)
        delegate?.didSaveExpenseItem(expenseItem)

        // Update yesterdayItems and todayItems based on the date of the added item
        let calendar = Calendar.current
        if calendar.isDateInYesterday(expenseItem.date!) {
            yesterdayItems.append(userExpenseItem)
        } else if calendar.isDateInToday(expenseItem.date!) {
            todayItems.append(userExpenseItem)
        }
        delegate?.didSaveExpenseItem(expenseItem)  

        updateDataSource()
        if let homeVC = navigationController?.viewControllers.first(where: { $0 is HomeViewController }) as? HomeViewController {
            homeVC.didSaveExpenseItem(expenseItem)
        }
    }

}

