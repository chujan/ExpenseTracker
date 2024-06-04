//
//  AppearanceViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 14/05/2024.
//

import UIKit
import PanModal

class AppearanceViewController: UIViewController {
    
    private let appearanceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 400, height: 400) // Adjust the item size as needed
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(appearanceCollectionView)
        appearanceCollectionView.dataSource = self
        appearanceCollectionView.delegate = self
        let closeButton = UIButton(type: .system)
        let cameraImage = UIImage(systemName: "xmark")
        closeButton.setImage(cameraImage, for: .normal)
        closeButton.backgroundColor = UIColor( white: 0.7, alpha: 1.0)
        closeButton.layer.cornerRadius = 20
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        appearanceCollectionView.register(ApperanceCollectionViewCell.self, forCellWithReuseIdentifier: ApperanceCollectionViewCell.identifier)

        // Position the button
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
          closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
                    appearanceCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                    appearanceCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    appearanceCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    appearanceCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension AppearanceViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(400)
    }
}
extension AppearanceViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Check if the shown view controller is the expected type
        if let homeDetailViewController = viewController as? SettingsViewController {
            // Do something with the shown view controller if needed
            print("Did show HomeDetailViewController")
        }
    }
    
    
}
extension AppearanceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ApperanceCollectionViewCell.identifier, for: indexPath) as? ApperanceCollectionViewCell else {
            return UICollectionViewCell()
        }
       
        return cell
    }
    
    
}

