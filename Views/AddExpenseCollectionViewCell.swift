//
//  AddExpenseCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 05/03/2024.
//

import UIKit
import CoreData

protocol AddExpenseViewControllerDelegate: AnyObject {
    func didSaveExpenseItem(_ expenseItem: Expense)
}

class AddExpenseCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    static let identifier = "AddExpenseCollectionViewCell"
    var expenseEntryCell: ExpenseEntryTableViewCell?
    var amountTextField = UITextField()
        var categoryTextField = UITextField()
        var itemTextField = UITextField()
    var dateTextField = UITextField()
    
    
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
    
    var expenseEntity: Expense?
    weak var delegate: AddViewControllerDelegate?
    var selectedCategories: [String] = []
    var updateTransactionItems: (([UserExpenseItem]) -> Void)?
    var userAddedItems: [UserExpenseItem] = [] {
           didSet {
               updateUI()
               updateUIs()
               
           }
       }
    
   
    lazy var managedObjectContext: NSManagedObjectContext = {
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           return appDelegate.persistentContainer.viewContext
       }()
    
   

   
    
    var updateUI: (() -> Void) = {}
    var   updateUIs: (() -> Void) = {}
    
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
           
           // button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemIndigo
            button.setTitle("Add Expense", for: .normal)

            button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
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
        dateTextField.text = ""
    }

   
    
    @objc private func startButtonTapped() {
        guard let expenseEntryCell =  expenseEntryCell else {
            print("Error: Income entry cell is nil")
            return
        }

        let amount  = expenseEntryCell.amountTextField.text ?? ""
        let category = expenseEntryCell.categoryTextField.text ?? ""
        let item = expenseEntryCell.itemTextField.text ?? ""
        let date = expenseEntryCell.currentDate

        let selectedCategory = selectedCategories.first ?? ""
        let time = timeFormatter.string(from: currentTime)

        // Check if the entered category exists in the predefined categories array
        let isValidCategory = categories.contains { $0.name == category }

        // Validate and save the data if the category is valid
        if amount.isEmpty || category.isEmpty || item.isEmpty {
            // Show an alert if any of the text fields are empty
            showFiledAlert()
        } else if !isValidCategory {
            // Show an alert if the category is invalid
            showAlert(withTitle: "Invalid Category", message: "Please select a valid category.")
        } else {
            // Your existing code to save the data
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
                        expenseEntryCell.resetTextFields()
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
                    
                } catch {
                    print("Error saving expense entity: \(error)")
                }
            } else {
                print("Error creating Expense entity")
            }
        }
    }

  
    
    
   
    
    private func showAlert(withTitle title: String, message: String) {
        // Find the topmost view controller
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            let alertController = UIAlertController(
                title: title,
                message: message,
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
    private func showFiledAlert() {
        // Find the topmost view controller
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            let alertController = UIAlertController(
                title: "Invalid input.",
                message: " Please fill in all fields",
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
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(startButton)
        timePicker.datePickerMode = .time
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        amountTextField.placeholder = ""
        categoryTextField.placeholder = ""
        itemTextField.placeholder = ""
       
        dateTextField.placeholder = ""
        
        
        amountTextField.delegate = self
               categoryTextField.delegate = self
               itemTextField.delegate = self
              
               dateTextField.delegate = self
        
     
        // Customize the cell with necessary UI elements
      
        dateTextField.inputView = datePicker
        datePicker.date = Date()
        
        

        
        let toolbar = UIToolbar()
                toolbar.barStyle = .default
                toolbar.isTranslucent = true
                toolbar.sizeToFit()
        amountTextField.returnKeyType = .done
                categoryTextField.returnKeyType = .done
                itemTextField.returnKeyType = .done
                dateTextField.returnKeyType = .done
       
               dateTextField.inputAccessoryView = toolbar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                       contentView.addGestureRecognizer(tapGesture)

        // Add the input fields to the cell's contentView
     
        contentView.backgroundColor = .systemBackground

        // Set up constraints
        setupConstraints()
        
    

    }



   
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func dismissKeyboard() {
                contentView.endEditing(true)
            }
    
    

    private func setupConstraints() {
        updateDateTextField()
        

        // Add constraints for the text fields
        NSLayoutConstraint.activate([
           
            
           
            startButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            startButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
          // startButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
            

            startButton.heightAnchor.constraint(equalToConstant: 50),
         
           
        ])

       
       
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn called")
        textField.resignFirstResponder()
        return true
    }

   

}





    

