//
//  IncomeEntryTableViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 01/03/2024.
//

import UIKit
import CoreData




class IncomeEntryTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    
    static let identifier = "IncomeEntryTableViewCell"
    var updateTransactionItems: (([UserIncomeItem]) -> Void)?
    var addIncomeCell: AddIncomeCollectionViewCell?
     var AddedItems: [UserIncomeItem] = []
    
    
    
   
    
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
    let yourDateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "your_date_format_here" // Replace with your actual date format
           return formatter
       }()
    
    func updateItem(withAmount amount: String, category: String, item: String, time: String, date: Date) {
            // Update the item in this cell with the provided values.
            // For example, update the text fields with new values.
            amountTextField.text = amount
            categoryTextField.text = category
            itemTextField.text = item
            timePicker.date = yourDateFormatter.date(from: time) ?? Date()
            currentDate = date
        }
    
 
   
    var currentDate: Date = Date() {
            didSet {
                datePicker.date = currentDate
                updateDateTextField()
            }
        }
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
    
    private let amountPlaceholderLabel: UILabel = {
            let label = UILabel()
        label.text = "Amount"
            label.textColor = UIColor.placeholderText
            label.font = UIFont.systemFont(ofSize: 17)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
   
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "₦"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.sizeToFit()
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
        label.text = "Description"
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
    
    

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            let addIncomeCell = AddIncomeCollectionViewCell() // Instantiate your AddIncomeCollectionViewCell
            addIncomeCell.updateTransactionItems = { [weak self] newItem in
                guard let self = self else { return }
                // Update the income cell with the new item
                self.AddedItems.append(contentsOf: newItem)
                self.updateTransactionItems?(self.AddedItems)
            }
            self.addIncomeCell = addIncomeCell
            
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
            
            amountTextField.clearsOnBeginEditing = false
            categoryTextField.clearsOnBeginEditing = false
            itemTextField.clearsOnBeginEditing = false
            dateTextField.clearsOnBeginEditing = false
            
            amountTextField.contentVerticalAlignment = .bottom
            categoryTextField.contentVerticalAlignment = .bottom
            itemTextField.contentVerticalAlignment = .bottom
            dateTextField.contentVerticalAlignment = .bottom
            
            // Set return key type to .done
            amountTextField.returnKeyType = .done
            categoryTextField.returnKeyType = .done
            itemTextField.returnKeyType = .done
            dateTextField.returnKeyType = .done
            
           
            
            // Add the input fields to the cell's contentView
            contentView.addSubview(amountTextField)
            contentView.addSubview(categoryTextField)
            contentView.addSubview(itemTextField)
            contentView.addSubview(dateTextField)
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
        
       
        
       
        
    
    func resetTextFields() {
        amountTextField.text = ""
        categoryTextField.text = ""
        itemTextField.text = ""
      
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("IncomeEntryTableViewCell - Text Field Changed: \(textField.text ?? "")")
        return true
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
            amountPlaceholderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7), // Adjust the top anchor to provide space
            amountPlaceholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            amountPlaceholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            //amountPlaceholderLabel.heightAnchor.constraint(equalToConstant: 30),

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
