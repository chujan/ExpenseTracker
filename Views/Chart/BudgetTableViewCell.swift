//
//  BudgetTableViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 08/04/2024.
//

import UIKit
import CoreData
protocol AddBudgetControllerDelegate: AnyObject {
    func didSaveExpenseItem(_ expenseItem: Category)
}
@objc(Category)
public class Category: NSManagedObject {
    @NSManaged public var amount: String?
       @NSManaged public var category: String?
    @NSManaged public var image: UIImage?
    @NSManaged public var date: Date?
    func setImageData(_ imageData: Data) {
           self.image = UIImage(data: imageData)
       }
}

class BudgetTableViewCell: UITableViewCell, UITextFieldDelegate{
    static let identifier = "BudgetTableViewCell"

   
    var updateTransactionItems: (([budgetAddedItem], String?) -> Void)?
    var expenseEntity: Category?
    weak var delegate: AddBudgetControllerDelegate?
    var selectedCategories: [String] = []
    let dateTextField = UITextField()
    
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
    
    var userAdded: [budgetAddedItem] = [] {
           didSet {
               updateUI()
           }
       }
    
   
    lazy var managedObjectContext: NSManagedObjectContext = {
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           return appDelegate.persistentContainer.viewContext
       }()
    
   

   var date = Date()
    
    var updateUI: (() -> Void) = {}
    var updateUIForDaily: (() -> Void) = {}
    
    
      
    
    lazy var startButton: UIButton = {
            let button = UIButton()
            button.isUserInteractionEnabled = true
            button.isEnabled = true
            button.layer.cornerRadius = 15
            
            button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemIndigo
            button.setTitle("Add Budget", for: .normal)

            button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
   
   
    
    let amountTextField = UITextField()
    let categoryTextField = UITextField()
    
    
    
   
    
   
  
    
    
    @objc private func startButtonTapped() {
        print("start button tapped")
      
       
        let selectedCategory = selectedCategories.first ?? ""
       
            
        let amount = amountTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        let date = currentDate
        
        dateTextField.inputView = datePicker
        datePicker.date = Date()
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
       

        // Validate and save the data
        if !amount.isEmpty, !category.isEmpty {
            
            if let expenseEntity = NSEntityDescription.insertNewObject(forEntityName: "Category", into: managedObjectContext) as? Category {
                expenseEntity.amount = amount
                expenseEntity.category = category
                expenseEntity.date = date
               

                // Save the managed object context
                do {
                    try managedObjectContext.save()

                    // Check if the item has been saved
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
                    fetchRequest.predicate = NSPredicate(format: "amount == %@ AND category == %@  AND date == %@", amount, category, date as CVarArg)

                    if let results = try managedObjectContext.fetch(fetchRequest) as? [Category], let savedItem = results.first {
                        // Item has been saved
                        print("Item saved with ID: \(savedItem.objectID)")
                        delegate?.didSaveExpenseItem(savedItem)
                    } else {
                        print("Error: Item not saved")
                    }

                    userAdded.append(budgetAddedItem(amount: amount, category: category,  image: nil, categoryBackgroundColor: backgroundColor(for: category), date: date))
                    updateTransactionItems?(userAdded, selectedCategory)
                   

                    // Update the UI
                    updateUI()
                    updateUIForDaily()
                    
                    showSuccessAlert()

                    // Optional: Clear the text fields after adding the item
                    amountTextField.text = ""
                    categoryTextField.text = ""
                   
                    // Dismiss the keyboard and hide the text fields
                    amountTextField.resignFirstResponder()
                    categoryTextField.resignFirstResponder()
                  
                   
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

    @objc private func dismissKeyboard() {
                contentView.endEditing(true)
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
        
       
        amountTextField.delegate = self
        categoryTextField.delegate = self
        dateTextField.delegate = self
            
        
  
        // Customize the cell with necessary UI elements
        amountTextField.placeholder = ""
        categoryTextField.placeholder = ""
        dateTextField.placeholder = ""
       
       
        
        
        amountTextField.clearsOnBeginEditing = false
        categoryTextField.clearsOnBeginEditing = false
        dateTextField.clearsOnBeginEditing = false
         
        amountTextField.contentVerticalAlignment = .bottom
        categoryTextField.contentVerticalAlignment = .bottom
      
      

        dateTextField.inputView = datePicker
        datePicker.date = Date()
        let toolbar = UIToolbar()
                toolbar.barStyle = .default
                toolbar.isTranslucent = true
                toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.setItems([spaceButton, doneButton], animated: false)

        dateTextField.inputAccessoryView = toolbar

       
       
             
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                       contentView.addGestureRecognizer(tapGesture)

        // Add the input fields to the cell's contentView
        contentView.addSubview(amountTextField)
        contentView.addSubview(categoryTextField)
        contentView.addSubview(dateTextField)
        contentView.addSubview(datePlaceholderLabel)
      
      
        
        contentView.addSubview(startButton)
        amountTextField.addSubview(currencyLabel)
        contentView.addSubview(amountPlaceholderLabel)
        contentView.addSubview(catgoryPlaceholderLabel)
        
        
        contentView.backgroundColor = .systemBackground

        // Set up constraints
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func dismissDatePicker() {
        dateTextField.resignFirstResponder()
    }

   

    private func setupConstraints() {
      
        [amountTextField, categoryTextField, dateTextField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Add constraints for the text fields
        NSLayoutConstraint.activate([
            amountPlaceholderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
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
            categoryTextField.heightAnchor.constraint(equalToConstant: 20),
            
            datePlaceholderLabel.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 8),
           datePlaceholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
           datePlaceholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            datePlaceholderLabel.heightAnchor.constraint(equalToConstant: 20),
            
            dateTextField.topAnchor.constraint(equalTo: datePlaceholderLabel.bottomAnchor, constant: 8),
           dateTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
           dateTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateTextField.heightAnchor.constraint(equalToConstant: 20),
           
            
            
            startButton.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 40),
            startButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: +20),
            startButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
           startButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
            startButton.widthAnchor.constraint(equalToConstant: 30),
    
            startButton.heightAnchor.constraint(equalToConstant: 50),
            
         
         
           
        ])

        // Add separator lines
        let separator1 = createSeparator()
        let separator2 = createSeparator()
        let separator3 = createSeparator()
      
        contentView.addSubview(separator1)
        contentView.addSubview(separator2)
        contentView.addSubview(separator3)
       

        NSLayoutConstraint.activate([
            separator1.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 8),
            separator1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator1.heightAnchor.constraint(equalToConstant: 1),

            separator2.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 8),
            separator2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator2.heightAnchor.constraint(equalToConstant: 1),
            
            separator3.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 8),
            separator3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator3.heightAnchor.constraint(equalToConstant: 1),

           
        ])
    }

    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    

    

  
}
