//
//  PanelViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 24/02/2024.
//

import UIKit
import PanModal

class PanelViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)))
        item.contentInsets = NSDirectionalEdgeInsets(top: +5, leading: 15, bottom: 0, trailing: 15)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
      
        return section
       }))
    
    var userAddedItems: [UserExpenseItem] = []
    init(userAddedItems: [UserExpenseItem]) {
            self.userAddedItems = userAddedItems
            
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AddedCollectionViewCell.self, forCellWithReuseIdentifier: AddedCollectionViewCell.identifier)
        

    }
    
    func totalAmount(for category: String) -> Double {
        let filteredItems = userAddedItems.filter { $0.category == category }
        let totalAmount = filteredItems.reduce(0.0) { $0 + (Double($1.amount) ?? 0.0) }
        return totalAmount
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
          collectionView.frame = view.bounds
        }
    func navigateToCategoryDetail(category: ExpenseCategory) {
        print("Navigating to category detail for: \(category.name)")
            
        let itemsForCategory = userAddedItems.filter { $0.category == category.name }

        // Calculate the total amount for the selected category
        let totalAmountForCategory = totalAmount(for: category.name)

        // Create a new instance of AddedDetailsViewController with the filtered items
        let categoryDetailViewController = AddedDetailsViewController(userAddedItems: itemsForCategory)
        categoryDetailViewController.totalAmountForSection0 = totalAmountForCategory
        categoryDetailViewController.selectedCategory = category.name // Pass the selected category name

        // Push the new view controller onto the navigation stack
        navigationController?.pushViewController(categoryDetailViewController, animated: true)

        // Set the title of the navigation bar to the selected category name
        navigationController?.navigationBar.topItem?.title = category.name
    }


}
extension PanelViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userAddedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedCollectionViewCell.identifier, for: indexPath) as? AddedCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = userAddedItems[indexPath.item]
        cell.configure(with: viewModel)
        return cell
    }
   
   

    
    
}

extension PanelViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(400)
    }
}
extension PanelViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Check if the shown view controller is the expected type
        if let homeDetailViewController = viewController as? HomeViewController {
            // Do something with the shown view controller if needed
            print("Did show HomeDetailViewController")
        }
    }
    
    
}


