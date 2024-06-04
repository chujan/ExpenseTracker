//
//  CategoryPanelViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 24/02/2024.
//

import UIKit
import PanModal
import CoreData

class CategoryPanelViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var categories: [ExpenseCategory] = []
    var userAddedItems: [UserExpenseItem] = []
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.7)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 8, trailing: 15) // Adjust the insets as needed
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitem: item, count: 4) // Adjust the count as needed
        let section = NSCollectionLayoutSection(group: group)
     
       
        return section
       }))
    
    init(userAddedItems: [UserExpenseItem], categories: [ExpenseCategory]) {
        self.userAddedItems = userAddedItems
        self.categories = categories
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func totalAmount(for category: String) -> Double {
        let filteredItems = userAddedItems.filter { $0.category == category }
        let totalAmount = filteredItems.reduce(0.0) { $0 + (Double($1.amount) ?? 0.0) }
        return totalAmount
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        view.addSubview(collectionView)
        navigationController?.delegate = self

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)

    }
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
          collectionView.frame = view.bounds
        }
    




    

    func navigateToCategoryDetail(category: ExpenseCategory) {
        // Filter the userAddedItems based on the selected category
        let itemsForCategory = userAddedItems.filter { $0.category == category.name }

        // Calculate the total amount for the selected category
        let totalAmountForCategory = totalAmount(for: category.name)

        // Create a new instance of AddedDetailsViewController with the filtered items
        let categoryDetailViewController = AddedDetailsViewController(userAddedItems: itemsForCategory, categories: categories)

        // Pass additional data if needed
        categoryDetailViewController.totalAmountForSection0 = totalAmountForCategory
        categoryDetailViewController.selectedCategory = category.name

        // Present the detail view controller
        let navigationController = UINavigationController(rootViewController: categoryDetailViewController)
        navigationController.modalPresentationStyle = .fullScreen
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(dismissDetailViewController)
        )
        categoryDetailViewController.navigationItem.leftBarButtonItem = backButton
        present(navigationController, animated: true, completion: nil)
    }


    

@objc private func dismissDetailViewController() {
    dismiss(animated: true, completion: nil)
}

}

extension CategoryPanelViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = categories[indexPath.row]
        cell.configure(with: nil, hasCategories: false)
        cell.configure(with: viewModel, hasCategories: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
            let selectedCategory = categories[indexPath.item]
            navigateToCategoryDetail(category: selectedCategory)
        
        
    }
    
    
}
                                            
extension CategoryPanelViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(600)
    }
}
extension CategoryPanelViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Check if the shown view controller is the expected type
        if let homeDetailViewController = viewController as? HomeViewController {
            // Do something with the shown view controller if needed
            print("Did show HomeDetailViewController")
        }
    }
}

