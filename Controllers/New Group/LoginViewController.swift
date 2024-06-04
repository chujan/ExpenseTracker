//
//  LoginViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 20/05/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController, LoginCollectionViewCellDelegate {
    let db = Firestore.firestore()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
              let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
              
              item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
              
              let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(550)), subitems: [item])
              let section = NSCollectionLayoutSection(group: group)
              return section
              
          }))
    
    func saveLoginTimestamp() {
           guard let userID = Auth.auth().currentUser?.uid else { return }
           
           let timestamp = Timestamp(date: Date())
           let userRef = db.collection("users").document(userID)
           
           userRef.updateData([
               "lastLogin": timestamp
           ]) { error in
               if let error = error {
                   print("Error updating login timestamp: \(error.localizedDescription)")
               } else {
                   print("Login timestamp successfully updated.")
               }
           }
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        setUpConstraints()
        view.backgroundColor = .systemBackground
        collectionView.register(LoginCollectionViewCell.self, forCellWithReuseIdentifier: LoginCollectionViewCell.identifier)
        
    }
    
    
    private func setUpConstraints() {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    
    public func  navigateToItemList() {
        let SignInVC  = SignInViewController()
        navigationController?.pushViewController(SignInVC, animated: true)
    }
    
    public func navigateToAnotherItemList() {
        let SignInVC  =  TabBarViewController()
        
        navigationController?.pushViewController(SignInVC, animated: true)
        
    }

   

}
extension LoginViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoginCollectionViewCell.identifier, for: indexPath) as? LoginCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    
}
