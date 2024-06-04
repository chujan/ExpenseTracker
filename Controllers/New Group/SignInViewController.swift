//
//  SignInViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 21/05/2024.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
              let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
              
              item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
              
              let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(550)), subitems: [item])
              let section = NSCollectionLayoutSection(group: group)
              return section
              
          }))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        setUpContraints()
        collectionView.register(SignInCollectionViewCell.self, forCellWithReuseIdentifier: SignInCollectionViewCell.identifier)
      

        checkIfUserHasAccount()
        view.backgroundColor = .systemBackground
        
        
       
    }
    private func checkIfUserHasAccount() {
              if let isUserLoggedIn = UserDefaults.standard.value(forKey: "isUserLoggedIn") as? Bool, isUserLoggedIn {
                  // User is logged in, navigate to the home screen
                  navigateAnotherItemList()
              }
          }
    
    public func navigateToAnotherItemList(){
        let SignInVC  =  LoginViewController()
        navigationController?.pushViewController(SignInVC, animated: true)
        
    }
    public func navigateAnotherItemList() {
       
        let SignInVC = TabBarViewController()
        navigationController?.pushViewController(SignInVC, animated: true)
        
    }
    
    public func navigateToChange() {
        let changeVC = ChangePasswordViewController()
        let navigationController = UINavigationController(rootViewController: changeVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)

        // Optionally, you can set a back button
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(dismissDetailViewController)
        )
        changeVC.navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc private func dismissDetailViewController() {
        dismiss(animated: true, completion: nil)
    }
   
    
    
    private func setUpContraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    


}

extension SignInViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignInCollectionViewCell.identifier, for: indexPath) as? SignInCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    
}
