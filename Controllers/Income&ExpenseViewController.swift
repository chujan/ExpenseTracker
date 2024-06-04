//
//  Income&ExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 20/05/2024.
//

import UIKit

class Income_ExpenseViewController: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return Income_ExpenseViewController.createSectionLayout(section: sectionIndex)
        
    })
    var  categories: [IncomeCategory] = []
    
    var  categorie: [ExpenseCategory] = []
    
    init(categories: [IncomeCategory], categorie: [ExpenseCategory]) {
        self.categories = categories
        self.categorie = categorie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        navigationItem.title = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(IncomeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: IncomeCategoryCollectionViewCell.identifier)
        collectionView.register(ExpenseCategoryCollectionViewCell.self, forCellWithReuseIdentifier: ExpenseCategoryCollectionViewCell.identifier)
        

        view .backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
          collectionView.frame = view.bounds
        }
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
      
        switch section {
            
        case 0:
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.7)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 8, trailing: 15) // Adjust the insets as needed
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitem: item, count: 4) // Adjust the count as needed
            let section = NSCollectionLayoutSection(group: group)
            
            
            return section
            
        case 1:
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.7)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 8, trailing: 15) // Adjust the insets as needed
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitem: item, count: 4) // Adjust the count as needed
            let section = NSCollectionLayoutSection(group: group)
            
            
            return section
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), repeatingSubitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            
            
            return section
        }
    }
    
    

   
}

extension Income_ExpenseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return categories.count
        case 1:
            return categorie.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IncomeCategoryCollectionViewCell.identifier, for: indexPath) as? IncomeCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            let category = categories[indexPath.item]
            cell.configure(with: category)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpenseCategoryCollectionViewCell.identifier, for: indexPath) as? ExpenseCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            let category = categorie[indexPath.item]
            cell.configure(with: category)
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
   
    
    
}
