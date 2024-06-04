//
//  AddIncomeCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 01/03/2024.
//

import UIKit
import CoreData

@objc(Income)
public class Income: NSManagedObject {
    @NSManaged public var income: String?
       @NSManaged public var category: String?
       @NSManaged public var source: String?
       @NSManaged public var time: String?
       @NSManaged public var date: Date?
    @NSManaged public var image: UIImage?
    func setImageData(_ imageData: Data) {
           self.image = UIImage(data: imageData)
       }
}
protocol AddIncomeViewControllerDelegate: AnyObject {
    func didSaveIncomeItem(_ incomeItem: Income)
    
}

class AddIncomeCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    var incomeEntryCell: IncomeEntryTableViewCell?
    var updateIncomeUI: (() -> Void) = {}
    private var totalIncome: Double = 0.0
   

    var amountTextField = UITextField()
        var categoryTextField = UITextField()
        var itemTextField = UITextField()
    var dateTextField = UITextField()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Text Field Changed: \(textField.text ?? "")")
        return true
    }
  
    var datePicker = UIDatePicker() // Change UITextField to UIDatePicker
     // Add a property for the delegate
    var incomeEntity: Income?
    weak var delegate: AddIncomeViewControllerDelegate?

    var selectedCategories: [String] = []
    var updateTransactionItems: (([UserIncomeItem]) -> Void)?
    var AddedItems: [UserIncomeItem] = [] {
           didSet {
               //updateUI()
           }
       }
    
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
    var currentTime: Date = Date() {
           didSet {
               timePicker.date = currentTime
               
           }
       }
    var currentDate: Date = Date() {
            didSet {
                datePicker.date = currentDate
                updateDateTextField()
            }
        }
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // Customize the format as needed
        return formatter
    }()
    
    private func updateDateTextField() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" // You can adjust the date format as needed
        dateTextField.text = dateFormatter.string(from: currentDate)
    }
    
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

   
    
    lazy var managedObjectContext: NSManagedObjectContext = {
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           return appDelegate.persistentContainer.viewContext
       }()
    
    static let identifier = "AddIncomeCollectionViewCell"
 
    lazy var startButton: UIButton = {
            let button = UIButton()
            button.isUserInteractionEnabled = true
            button.isEnabled = true
            button.layer.cornerRadius = 12
            
           
           // button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemIndigo
            button.setTitle("Add Income", for: .normal)

            button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    
    
    
    @objc private func startButtonTapped() {
        guard let incomeEntryCell = incomeEntryCell else {
            print("Error: Income entry cell is nil")
            return
        }
        
        let income = incomeEntryCell.amountTextField.text ?? ""
        let category = incomeEntryCell.categoryTextField.text ?? ""
        let item = incomeEntryCell.itemTextField.text ?? ""
        let date = incomeEntryCell.currentDate
        
        let rawTime = timePicker.date
        let time = timeFormatter.string(from: rawTime)
        let isValidCategory = incomeCategories.contains { $0.name == category }
        
        // Check if all fields are filled
        if !income.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           !category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           !item.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           !time.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Check if the entered category exists in the predefined categories array
            let isValidCategory = incomeCategories.contains { $0.name == category }
            
            // Validate and save the data if the category is valid
            if income.isEmpty || category.isEmpty || item.isEmpty {
                // Show an alert if any of the text fields are empty
                showFiledAlert()
            } else if !isValidCategory {
                // Show an alert if the category is invalid
                showAlert(withTitle: "Invalid Category", message: "Please select a valid category.")
            } else {
                // Your existing code to save the data
                if let incomeEntity = NSEntityDescription.insertNewObject(forEntityName: "Income", into: managedObjectContext) as? Income {
                    incomeEntity.income = income
                    incomeEntity.category = category
                    incomeEntity.source = item
                    incomeEntity.time = time
                    incomeEntity.date = date
                    
                    // Save the managed object context
                    do {
                        try managedObjectContext.save()
                        
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Income")
                        fetchRequest.predicate = NSPredicate(format: "income == %@ AND category == %@ AND source == %@ AND time == %@ AND date == %@", income, category, item, time, date as CVarArg)
                        
                        if let results = try managedObjectContext.fetch(fetchRequest) as? [Income], let savedItem = results.first {
                            print("Item saved with ID: \(savedItem.objectID)")
                            delegate?.didSaveIncomeItem(savedItem)
                            incomeEntryCell.resetTextFields()
                        } else {
                            print("Error: Item not saved")
                        }
                        
                        AddedItems.append(UserIncomeItem(income: income, category: category, itemName: item, time: time, date: date, image: nil, categoryBackgroundColor: backgroundColor(for: category)))
                        updateTransactionItems?(AddedItems)
                        
                        showSuccessAlert()
                        updateIncomeUI()
                        
                        amountTextField.text = ""
                        categoryTextField.text = ""
                        itemTextField.text = ""
                        dateTextField.text = ""
                        
                        amountTextField.resignFirstResponder()
                        categoryTextField.resignFirstResponder()
                        itemTextField.resignFirstResponder()
                        dateTextField.resignFirstResponder()
                        // Dismiss the keyboard and hide the text fields
                        
                    } catch {
                        print("Error saving expense entity: \(error)")
                    }
                } else {
                    print("Error creating Expense entity")
                }
            }
        }
    }


    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(startButton)
        setupContraints()
        timePicker.datePickerMode = .time
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.delegate = self
               categoryTextField.delegate = self
               itemTextField.delegate = self
              
               dateTextField.delegate = self
        
  
        // Customize the cell with necessary UI elements
        amountTextField.placeholder = ""
        categoryTextField.placeholder = ""
        itemTextField.placeholder = ""
       
        dateTextField.placeholder = ""
        
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

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    @objc private func dismissDatePicker() {
        dateTextField.resignFirstResponder()
    }

    
    @objc private func dismissKeyboard() {
                contentView.endEditing(true)
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
    
   
    func resetTextFields() {
        amountTextField.text = ""
        categoryTextField.text = ""
        itemTextField.text = ""
        dateTextField.text = ""
    }

    
    private func setupContraints() {
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            startButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
           //startButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            

            startButton.heightAnchor.constraint(equalToConstant: 50),
        ])
       
        
        
    }
    
   
    
}




