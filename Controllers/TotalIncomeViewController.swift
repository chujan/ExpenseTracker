//
//  TotalIncomeViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 05/03/2024.
//

import UIKit
import PanModal

class TotalIncomeViewController: UIViewController {
    var categories: [IncomeCategory] = []
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.7)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15) // Adjust the insets as needed
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitem: item, count: 4) // Adjust the count as needed
        let section = NSCollectionLayoutSection(group: group)
       
        return section
       }))
    
    init(categories: [IncomeCategory]) {
            self.categories = categories
            super.init(nibName: nil, bundle: nil)
           
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(IncomeCategoriesCollectionViewCell.self, forCellWithReuseIdentifier: IncomeCategoriesCollectionViewCell.identifier)
        
    }
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
          collectionView.frame = view.bounds
        }
    
    
   

   
}
extension TotalIncomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IncomeCategoriesCollectionViewCell.identifier, for: indexPath) as? IncomeCategoriesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = categories[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    
}

extension TotalIncomeViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(400)
    }
}
extension TotalIncomeViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Check if the shown view controller is the expected type
        if let homeDetailViewController = viewController as? TotalIncomeViewController {
            // Do something with the shown view controller if needed
            print("Did show HomeDetailViewController")
        }
    }
}
