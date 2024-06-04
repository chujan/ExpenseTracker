//
//  NotificationCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 08/05/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class NotificationCollectionViewCell: UICollectionViewCell {
    static let identifier = "NotificationCollectionViewCell"
    
    var currentUser: User? {
        didSet {
           commonInit()
            fetchUserData()
        
        }
    }
    
    
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let personButton: UIButton = {
        let button = UIButton()
        let systemImageName = "person"
        let systemImage = UIImage(systemName: systemImageName)
        button.setImage(systemImage, for: .normal)
        button.contentMode = .scaleAspectFill
        button.tintColor = .systemIndigo
        button.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        button.addTarget(self, action: #selector(viewButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.isHidden = true
        return label
    }()
    
    private let bellButton: UIButton = {
        let button = UIButton()
        let systemImageName = "bell"
        let systemImage = UIImage(systemName: systemImageName)
        button.setImage(systemImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .systemIndigo
        button.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        button.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private var greetingTimer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(personButton)
        contentView.addSubview(bellButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(helloLabel)
        contentView.addSubview(greetingLabel)
        bellButton.addSubview(badgeLabel)
        commonInit()
        fetchUserData()
        setUserInfo()
        setupUserInfo()
        updateGreetingLabel()
        
        setUpConstraints()
        if let savedImage = loadProfileImage() {
            personButton.setImage(savedImage, for: .normal)
        }
        startGreetingTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(profileImageChanged), name: .profileImageChanged, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        greetingTimer?.invalidate()
      
        NotificationCenter.default.removeObserver(self, name: .profileImageChanged, object: nil)
    }
    func updateNameLabel(with user: User) {
           nameLabel.text = "\(user.firstName) \(user.lastName)"
       }
       
       public func commonInit() {
           if let currentUser = currentUser {
               nameLabel.text = "\(currentUser.firstName) \(currentUser.lastName)"
               configureUserDetails()
           } else {
               nameLabel.text = ""
           }
       }
       
       private func configureUserDetails() {
           guard let currentUser = currentUser else { return }
           nameLabel.text = currentUser.firstName
       }
       
       func setupUserInfo() {
          
       }
    
    func setUserInfo() {
            if let userData = SharedData.shared.userData {
                let firstName = userData["firstName"] as? String ?? ""
                let lastName = userData["lastName"] as? String ?? ""
                self.currentUser = User(firstName: firstName, lastName: lastName)
            }
        }
    
    private let db = Firestore.firestore()
       
    func fetchUserData() {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let userRef = db.collection("users").document(uid)
            userRef.getDocument { [weak self] (document, error) in
                guard let self = self else { return }
                if let document = document, document.exists {
                    let data = document.data()
                    let firstName = data?["firstName"] as? String ?? ""
                    let lastName = data?["lastName"] as? String ?? ""
                    let email = data?["email"] as? String ?? ""
                    
                    // Create a User object
                    let user = User(uid: uid, firstName: firstName, lastName: lastName, email: email)
                    
                    // Set the currentUser property
                    self.currentUser = user
                } else {
                    print("User does not exist")
                }
            }
        }

       
       private func updateNameLabel(with firstName: String, lastName: String) {
           DispatchQueue.main.async {
               self.nameLabel.text = "\(firstName) \(lastName)"
           }
       }
       
      
       
    private func saveProfileImage(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: "profileImageData")
        }
    }

    private func loadProfileImage() -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: "profileImageData"),
           let image = UIImage(data: imageData) {
            return image
        }
        return nil
    }
    
  
   
    @objc private func viewButtonTapped() {
        print("Button tapped!")
        if let parentViewController = findParentViewController() as? HomeViewController {
            parentViewController.navigateToAccountVC()
        }
    }
    
    @objc private func bellButtonTapped() {
        if let parentViewController = findParentViewController() as? HomeViewController {
            parentViewController.navigateToNotifyVC()
            updateBadge(count: 0)
        }
    }
    
    
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            helloLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            helloLabel.leadingAnchor.constraint(equalTo: personButton.leadingAnchor, constant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: helloLabel.leadingAnchor, constant: 50),
            
            greetingLabel.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 5),
            greetingLabel.leadingAnchor.constraint(equalTo: personButton.leadingAnchor, constant: 60)
        ])
    }
    
    @objc private func updateGreetingLabel() {
        greetingLabel.text = "\(getGreeting())"
    }
    
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<21:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonWidth: CGFloat = 45
        let buttonHeight: CGFloat = 45

        personButton.frame = CGRect(
            x: 15,
            y: (contentView.frame.height - buttonHeight) / 2,
            width: buttonWidth,
            height: buttonHeight
        )

        personButton.layer.cornerRadius = buttonWidth / 2
        
        bellButton.frame = CGRect(
            x: contentView.frame.width - buttonWidth - 15,
            y: (contentView.frame.height - buttonHeight) / 2,
            width: buttonWidth,
            height: buttonHeight
        )

        bellButton.layer.cornerRadius = buttonWidth / 2
        
        let badgeSize: CGFloat = 20
        badgeLabel.frame = CGRect(x: bellButton.frame.width - badgeSize / 2, y: -badgeSize / 2, width: badgeSize, height: badgeSize)
    }
    
    func updateBadge(count: Int) {
        if count > 0 {
            badgeLabel.isHidden = false
            badgeLabel.text = "\(count)"
        } else {
            badgeLabel.isHidden = true
        }
    }
    
    func updateNotification(message: String) {
        badgeLabel.text = message
    }

    private func startGreetingTimer() {
        greetingTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateGreetingLabel), userInfo: nil, repeats: true)
    }

    @objc private func profileImageChanged() {
        if let savedImage = loadProfileImage() {
            personButton.setImage(savedImage, for: .normal)
        }
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

extension Notification.Name {
    static let profileImageChanged = Notification.Name("profileImageChanged")
}

extension Notification.Name {
    static let userDataUpdated = Notification.Name("userDataUpdated")
}
