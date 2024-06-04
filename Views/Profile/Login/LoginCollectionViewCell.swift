//
//  LoginCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 20/05/2024.
//



import UIKit
import FirebaseAuth

import FirebaseFirestore

protocol LoginCollectionViewCellDelegate: AnyObject {
    func saveLoginTimestamp()
}


class LoginCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    weak var delegate: LoginCollectionViewCellDelegate?
    
    

    
    let db = Firestore.firestore()
    static let identifier = "LoginCollectionViewCell"
    var profileCollectionViewCell: ProfileCollectionViewCell?
    var notificationViewCell: NotificationCollectionViewCell?
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's get rolling"
        label.textColor = .systemIndigo
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25, weight: .medium)
        return label
    }()
    
    let logLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemIndigo
        label.text = "Create account to get started"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .systemGray
        textField.backgroundColor = UIColor(white: 0.88, alpha: 1.0)
        textField.font = .systemFont(ofSize: 15, weight: .bold)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter Firstname",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .systemGray
        textField.backgroundColor = UIColor(white: 0.88, alpha: 1.0)
        textField.font = .systemFont(ofSize: 15, weight: .bold)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Lastname",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .darkGray
        textField.backgroundColor = UIColor(white: 0.88, alpha: 1.0)
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 15, weight: .bold)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4]
        )
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .systemGray
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0.88, alpha: 1.0)
        textField.font = .systemFont(ofSize: 15, weight: .bold)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .systemIndigo
        return button
    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Already have an account? Sign In", for: .normal)
        button.setTitleColor(.systemIndigo, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        setupActions()
        checkIfUserHasAccount()
       
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.returnKeyType = .done
        lastNameTextField.returnKeyType = .done
        emailTextField.returnKeyType = .done
        passwordTextField.returnKeyType = .done
    }
    
    private func setupSubviews() {
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(logLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(createAccountButton)
        contentView.addSubview(signInButton)
    }
    
    private func setupActions() {
        createAccountButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signButtonTapped), for: .touchUpInside)
    }
    
    @objc private func createButtonTapped() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
              let password = passwordTextField.text,
              let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              !email.isEmpty, !password.isEmpty, !firstName.isEmpty, !lastName.isEmpty else {
            showAlert(title: "Empty Fields", message: "Fields must not be empty!")
            return
        }
        
        guard isPasswordValid(password) else {
            showAlert(title: "Invalid Password", message: "Password must contain at least 8 characters, including an uppercase letter, a lowercase letter, and a number or special character.")
            return
        }
        
        createAccountButton.isEnabled = false
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                createAccountButton.isEnabled = true
                showAlert(title: "Error", message: "Error signing out: \(signOutError.localizedDescription)")
                return
            }
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            self.createAccountButton.isEnabled = true
            
            if let error = error {
                self.showAlert(title: "Error", message: "Account creation failed: \(error.localizedDescription)")
            } else if let user = authResult?.user {
                let currentUser = User(uid: user.uid, firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", email: user.email ?? "")
                UserDefaults.standard.set(user.uid, forKey: "userID")
                UserDefaults.standard.set(currentUser.toDictionary(), forKey: "currentUser")
                UserDefaults.standard.synchronize()
                self.profileCollectionViewCell?.currentUser = currentUser
                self.notificationViewCell?.currentUser = currentUser

                self.saveUserToFirestore(uid: user.uid, email: email,  firstName: firstName, lastName: lastName)
                self.delegate?.saveLoginTimestamp()
                self.navigateToItemList()
                self.resetTextFields()
            } else {
                self.showAlert(title: "Error", message: "Unexpected error occurred during account creation.")
            }
        }
    }

    func validateAndNormalizeEmail(_ email: String) -> String? {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailPredicate.evaluate(with: trimmedEmail) else {
            return nil
        }
        
        return trimmedEmail.lowercased()
    }

    func saveUserToFirestore(uid: String, email: String, firstName: String, lastName: String) {
        let userRef = db.collection("users").document(uid)
        userRef.setData([
            "uid": uid,
            "email": email,
            "firstName": firstName,
            "lastName": lastName
        ]) { error in
            if let error = error {
                print("Error saving user to Firestore: \(error.localizedDescription)")
            } else {
                print("User successfully saved to Firestore")
                let user = User(uid: uid, firstName: firstName, lastName: lastName, email: email)
                
                UserDefaults.standard.set(uid, forKey: "currentUser")
                self.notificationViewCell?.currentUser = user
               
                
            }
        }
    }
    
    private func checkIfUserHasAccount() {
            if let userID = UserDefaults.standard.string(forKey: "userID"),
               let userDict = UserDefaults.standard.dictionary(forKey: "currentUser"),
               let firstName = userDict["firstName"] as? String,
               let lastName = userDict["lastName"] as? String,
               let email = userDict["email"] as? String {

                // All required values are available, create a User instance
                let user = User(uid: userID, firstName: firstName, lastName: lastName, email: email)

                // User is logged in, update the ProfileSectionHeaderView
               profileCollectionViewCell?.currentUser = user
                notificationViewCell?.currentUser = user
             

                // Navigate to the home screen
              
            } else {
                // User information is not available, clear data or handle accordingly
              
            }
        }

    private func navigateToItemList() {
        if let parentViewController = findParentViewController() as? LoginViewController {
            parentViewController.navigateToAnotherItemList()
        } else {
            // Handle the case where the parent view controller is not of type LoginViewController
        }
    }
    
    private func resetTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        firstNameTextField.text = ""
        lastNameTextField.text = ""
    }
    
    @objc private func signButtonTapped() {
        if let parentViewController = findParentViewController() as? LoginViewController {
            parentViewController.navigateToItemList()
        } else {
            // Handle the case where the parent view controller is not of type LoginViewController
        }
    }
    
    private func showAlert(title: String, message: String) {
        guard let topViewController = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        topViewController.present(alertController, animated: true, completion: nil)
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@",
                                        "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[#$^+=!*()@%&]).{8,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            logLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            logLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            firstNameTextField.topAnchor.constraint(equalTo: logLabel.bottomAnchor, constant: 20),
            firstNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            firstNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 10),
            lastNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            createAccountButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            createAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            createAccountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 10),
            signInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
