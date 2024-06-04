//
//  ChangeTableViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 13/05/2024.
//

import UIKit
import FirebaseAuth

class ChangeTableViewCell: UITableViewCell, UITextFieldDelegate {

    static let identifier = "ChangeTableViewCell"

    private let currentPassordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0.88, alpha: 1.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
               string: "Enter Your Current Email",
               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
           )
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0.88, alpha: 1.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
               string: "Enter a new  password",
               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
           )
        return textField
    }()

    private let confirmTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0.88, alpha: 1.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
               string: "Confirm Password",
               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
           )
        return textField
    }()

    private let forgotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .systemGray2
        label.text = "Forgot Password?"
        return label
    }()

    private let letLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .systemIndigo
        label.text = "Let's get you back"
        return label
    }()

   
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemIndigo
        button.setTitle("Reset Password", for: .normal)
        button.titleLabel?.font = .monospacedSystemFont(ofSize: 17, weight: .bold)
        button.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    @objc private func resetPasswordButtonTapped() {
        guard let email = currentPassordTextField.text, !email.isEmpty else {
            displayError(for: currentPassordTextField, message: "Email must not be empty")
            return
        }

        guard isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self?.showAlert(title: "Success", message: "Password reset email sent!")
                self?.navigateToItemList()
            }
        }
    }

    private func reauthenticateUser(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { result, error in
            if let _ = error {
                completion(false)
            } else {
                completion(true)
            }
        })
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[0-9]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

    private func navigateSignInVC() {
        let signInVC = UINavigationController(rootViewController:  ChangePasswordViewController())
        signInVC.modalPresentationStyle = .fullScreen
        self.window?.rootViewController?.present(signInVC, animated: true, completion: nil)
    }

    private func displayError(for textField: UITextField, message: String) {
        textField.textColor = .red
        textField.text = message
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == .red {
            textField.textColor = .systemGray2
            textField.text = ""
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    private func navigateToItemList() {
        if let parentViewController = self.findParentViewController() as? ChangePasswordViewController {
            parentViewController.navigateAnotherItemList()
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        currentPassordTextField.returnKeyType = .done
        passwordTextField.returnKeyType = .done
        confirmTextField.returnKeyType = .done
        currentPassordTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        setupConstraints()
    }

    private func setupConstraints() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(forgotLabel)
        contentView.addSubview(letLabel)
        contentView.addSubview(confirmTextField)
        contentView.backgroundColor = .systemBackground

        contentView.addSubview(currentPassordTextField)
        contentView.addSubview(passwordTextField)
        
        contentView.addSubview(resetPasswordButton)

        NSLayoutConstraint.activate([
            forgotLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            forgotLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            forgotLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            letLabel.topAnchor.constraint(equalTo: forgotLabel.bottomAnchor, constant: 10),
            letLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            letLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            currentPassordTextField.topAnchor.constraint(equalTo: letLabel.bottomAnchor, constant: 30),
            currentPassordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currentPassordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            currentPassordTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: currentPassordTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            confirmTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            confirmTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            confirmTextField.heightAnchor.constraint(equalToConstant: 50),

           
            resetPasswordButton.topAnchor.constraint(equalTo: confirmTextField.bottomAnchor, constant: 25),
            resetPasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resetPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resetPasswordButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    private func findParentViewController() -> UIViewController? {
           var responder: UIResponder? = self
           while let nextResponder = responder?.next {
               responder = nextResponder
               if let viewController = responder as? UIViewController {
                   return viewController
               }
           }
           return nil
       }
  
   
}
