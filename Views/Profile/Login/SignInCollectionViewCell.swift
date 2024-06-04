//
//  SignInCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 21/05/2024.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

class SharedData {
    static let shared = SharedData()
    var userData: [String: Any]?
}


class SignInCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    static let identifier = "SignInCollectionViewCell"
  
    
    var userData: [String: Any]?
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textColor = .systemIndigo
        return label
    }()
    
    private let signLabel: UILabel = {
        let label = UILabel()
        label.text = "Signin to get started"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .systemIndigo
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .systemGray2
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0.88, alpha: 1.0)
        textField.font = .systemFont(ofSize: 15, weight: .bold)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
               string: "Enter Email",
               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
           )
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .systemGray2
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
    
    let signinAccountButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .systemIndigo
        return button
    }()
    
    let forgetPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.systemIndigo, for: .normal)
        return button
    }()
    
    let creatAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Dont have an Account? Create one", for: .normal)
        button.setTitleColor(.systemIndigo, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(signLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(signinAccountButton)
        contentView.addSubview(creatAccountButton)
        contentView.addSubview(forgetPasswordButton)
     

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        creatAccountButton.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
        forgetPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        signinAccountButton.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        setUpContraint()
        emailTextField.returnKeyType = .done
        passwordTextField.returnKeyType = .done
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    @objc private func createAccountTapped() {
        if let parentViewController = findParentViewController() as? SignInViewController {
            parentViewController.navigateToAnotherItemList()
        } else {
            // Handle the case where the parent view controller is not of type LoginViewController
        }
    }
    
    @objc private func forgotPasswordButtonTapped() {
        if let parentViewController = findParentViewController() as? SignInViewController {
            parentViewController.navigateToChange()
        } else {
            // Handle the case where the parent view controller is not of type LoginViewController
        }
    }
    
    private func navigateTabVC() {
        if let parentViewController = self.findParentViewController() as? SignInViewController {
            parentViewController.navigateAnotherItemList()
        }
    }
    
    
    @objc private func signinButtonTapped() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), !email.isEmpty else {
            displayError(for: emailTextField, message: "Email must not be empty")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            displayError(for: passwordTextField, message: "Password must not be empty")
            return
        }
        
        if !isPasswordValid(password) {
            showAlert(title: "Invalid Password", message: "Password should contain at least 8 characters, including both upper and lower case, and at least one number")
            return
        }
        
        // Log the email being used for signing in
        print("Signing in with email: \(email)")
        
        // Fetch user data from Firestore based on the entered email
        fetchUserData(email: email)
            
            
        
    }
    
    private func fetchUserData(email: String) {
            let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            print("Attempting to fetch user data for sign-in email: \(normalizedEmail)")

            let db = Firestore.firestore()
            let usersRef = db.collection("users").whereField("email", isEqualTo: normalizedEmail)

            usersRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching user data: \(error)")
                    self.showAlert(title: "Error", message: "Failed to fetch user data from Firestore.")
                    return
                }

                guard let documents = querySnapshot?.documents, !documents.isEmpty, let userData = documents.first?.data() else {
                    print("User not found in Firestore for email: \(normalizedEmail)")
                    self.showAlert(title: "Error", message: "User not found.")
                    return
                }

                if let storedEmail = userData["email"] as? String, storedEmail.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == normalizedEmail {
                    print("User fetched from Firestore: \(userData["firstName"] ?? "") with email: \(userData["email"] ?? "")")
                    // Update UI with fetched user data
                    SharedData.shared.userData = userData 
                    self.navigateTabVC()
                } else {
                    print("Email mismatch between sign-in and stored email")
                    self.showAlert(title: "Error", message: "Email mismatch between sign-in and stored email.")
                }
            }
        }

    


    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d|[!@#$%^&*()-_=+{};:,<.>?/~`])\\S{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    private func resetTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    private func showPasswordResetErrorAlert(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    private func setUpContraint() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            signLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            signLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            signLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            emailTextField.topAnchor.constraint(equalTo: signLabel.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signinAccountButton.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: 50),
            signinAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            signinAccountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            signinAccountButton.heightAnchor.constraint(equalToConstant: 50),
            
            forgetPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            creatAccountButton.topAnchor.constraint(equalTo: signinAccountButton.bottomAnchor, constant: 10),
            creatAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            creatAccountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
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

