//
//  EmailTableViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 15/05/2024.
//

import UIKit

class EmailTableViewCell: UITableViewCell, UITextFieldDelegate {
    static let identifier = "EmailTableViewCell"
    
    let currentPassordTextField = UITextField()
    let createNewPassWordTextField = UITextField()
    let confirmeNewPassWordTextField = UITextField()
    
    
private let currentPlaceholderLabel: UILabel = {
    let label = UILabel()
    label.text = "CurrentEmail"
    label.textColor = UIColor.systemGray2
    label.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()
        private let createPlaceholderLabel: UILabel = {
            let label = UILabel()
            label.text = "Create a New Email"
            label.textColor = UIColor.systemGray2
            label.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private let confirmPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm New Email"
        label.textColor = UIColor.systemGray2
        label.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
lazy var changeButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.isEnabled = true
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.systemGray2.cgColor
       // button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.setTitle("Change Email", for: .normal)

        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
@objc private func startButtonTapped() {
}
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupConstraints()
        currentPassordTextField.delegate = self
        createNewPassWordTextField.delegate = self
        confirmeNewPassWordTextField.delegate = self
        contentView.backgroundColor = .systemBackground
        
        

        
       
        

        
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
    
    private func setupConstraints() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(currentPlaceholderLabel)
        contentView.addSubview(currentPassordTextField)
        contentView.addSubview(createPlaceholderLabel)
        contentView.addSubview(createNewPassWordTextField)
        contentView.addSubview(confirmPlaceholderLabel)
        contentView.addSubview(confirmeNewPassWordTextField)
        contentView.addSubview(changeButton)
        
        currentPassordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmeNewPassWordTextField.translatesAutoresizingMaskIntoConstraints = false
        createNewPassWordTextField.translatesAutoresizingMaskIntoConstraints = false
        changeButton.translatesAutoresizingMaskIntoConstraints = false

        // Activate constraints
        NSLayoutConstraint.activate([
            currentPlaceholderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            currentPlaceholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currentPlaceholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            currentPassordTextField.topAnchor.constraint(equalTo: currentPlaceholderLabel.bottomAnchor, constant: 8),
            currentPassordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currentPassordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            

            createPlaceholderLabel.topAnchor.constraint(equalTo: currentPassordTextField.bottomAnchor, constant: 8),
            createPlaceholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            createPlaceholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            createPlaceholderLabel.heightAnchor.constraint(equalToConstant: 30),

            createNewPassWordTextField.topAnchor.constraint(equalTo: createPlaceholderLabel.bottomAnchor, constant: 8),
            createNewPassWordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            createNewPassWordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            

            confirmPlaceholderLabel.topAnchor.constraint(equalTo: createNewPassWordTextField.bottomAnchor, constant: 8),
            confirmPlaceholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            confirmPlaceholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            confirmPlaceholderLabel.heightAnchor.constraint(equalToConstant: 30),

            confirmeNewPassWordTextField.topAnchor.constraint(equalTo: confirmPlaceholderLabel.bottomAnchor, constant: 8),
            confirmeNewPassWordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            confirmeNewPassWordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            changeButton.topAnchor.constraint(equalTo: confirmeNewPassWordTextField.bottomAnchor, constant: 100),
            changeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
           changeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
          changeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
          changeButton.widthAnchor.constraint(equalToConstant: 50),
    
          changeButton.heightAnchor.constraint(equalToConstant: 50),
            
         
        ])

        // Add separators
        let separator1 = createSeparator()
        let separator2 = createSeparator()
        let separator3 = createSeparator()

        contentView.addSubview(separator1)
        contentView.addSubview(separator2)
        contentView.addSubview(separator3)

        NSLayoutConstraint.activate([
            separator1.topAnchor.constraint(equalTo: currentPassordTextField.bottomAnchor, constant: 8),
            separator1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator1.heightAnchor.constraint(equalToConstant: 1),

            separator2.topAnchor.constraint(equalTo: createNewPassWordTextField.bottomAnchor, constant: 8),
            separator2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator2.heightAnchor.constraint(equalToConstant: 1),

            separator3.topAnchor.constraint(equalTo: confirmeNewPassWordTextField.bottomAnchor, constant: 8),
            separator3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator3.heightAnchor.constraint(equalToConstant: 1)
        ])
    }


 
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Log a message to verify if the method is being called
        print("shouldChangeCharactersIn method called")

        // Here you can handle the text change if needed.
        // For example, if you want to limit the text length:
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            // Limit the text field to 20 characters
            return updatedText.count <= 20
        }
        return true
    }

    

}





