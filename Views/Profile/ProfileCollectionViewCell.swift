//
//  ProfileCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 10/05/2024.
//

import UIKit
import FirebaseFirestore

class ProfileCollectionViewCell: UICollectionViewCell, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    static let identifier = "ProfileCollectionViewCell"
    
    var currentUser: User? {
        didSet {
            commonInit()
        }
    }
    
    
    
    private var buttonTappedAction: (() -> Void)?
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    let changeImageButton: UIButton = {
        let button = UIButton()
        let cameraImage = UIImage(systemName: "camera")
        button.setImage(cameraImage, for: .normal)
        button.tintColor = .systemIndigo
        button.backgroundColor = UIColor(white: 0.7, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(profileImageView)
        contentView.addSubview(changeImageButton)
        contentView.addSubview(nameLabel)
        profileImageView.layer.cornerRadius = 100
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .systemGray2
        setConstraints()
        commonInit()
        setUserInfo()
        setupUserInfo()
        changeImageButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        if let savedImage = loadProfileImage() {
            profileImageView.image = savedImage
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
       
        nameLabel.text = "\(currentUser.firstName) \(currentUser.lastName)"
    }
    
    func setupUserInfo() {
        // Fetch user data from Firestore
        fetchUserDataFromFirestore()
    }
    
    func setUserInfo() {
            if let userData = SharedData.shared.userData {
                let firstName = userData["firstName"] as? String ?? ""
                let lastName = userData["lastName"] as? String ?? ""
                self.currentUser = User(firstName: firstName, lastName: lastName)
            }
        }
    
    private func fetchUserDataFromFirestore() {
            guard let currentUserID = UserDefaults.standard.string(forKey: "currentUser") else {
                print("No current user ID found in UserDefaults")
                return
            }
            
            let db = Firestore.firestore()
            db.collection("users").document(currentUserID).getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let firstName = data?["firstName"] as? String ?? ""
                    let lastName = data?["lastName"] as? String ?? ""
                    
                    let fetchedUser = User(firstName: firstName, lastName: lastName)
                    
                    DispatchQueue.main.async {
                        self.currentUser = fetchedUser
                       
                    }
                } else {
                    print("Document does not exist or there was an error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

    
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    public func showImagePickerOption() {
        let alertVC = UIAlertController(title: "Pick a Photo", message: "Choose a picture from Library or camera", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            self.window?.rootViewController?.present(cameraImagePicker, animated: true, completion: nil)
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            self.window?.rootViewController?.present(libraryImagePicker, animated: true) {}
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let circularImage = image.circularImage(with: profileImageView.bounds.size)
            saveProfileImage(circularImage)
            profileImageView.image = circularImage
            NotificationCenter.default.post(name: .profileImageChanged, object: nil)
          
        }
        picker.dismiss(animated: true, completion: nil)
    }

    private func saveProfileImage(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: "profileImageData")
            UserDefaults.standard.synchronize()
        }
    }
    
    private func loadProfileImage() -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: "profileImageData"),
           let image = UIImage(data: imageData) {
            return image
        }
        return nil
    }
    
    @objc private func changeProfilePictureTapped() {
        print("all")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 200),
            profileImageView.widthAnchor.constraint(equalToConstant: 200),
            changeImageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
            changeImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -70),
            changeImageButton.widthAnchor.constraint(equalToConstant: 40),
            changeImageButton.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }

    public func configure(buttonImage: UIImage, buttonTappedAction: (() -> Void)?) {
        changeImageButton.setImage(buttonImage, for: .normal)
        self.buttonTappedAction = buttonTappedAction
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        buttonTappedAction?()
    }
}

extension UIImage {
    func circularImage(with size: CGSize) -> UIImage {
        let imageSize = size.width > size.height ? CGSize(width: size.height, height: size.height) : size
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        return renderer.image { context in
            let roundedRect = CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize)
            context.cgContext.addEllipse(in: roundedRect)
            context.cgContext.clip()
            draw(in: roundedRect)
        }
    }
}
