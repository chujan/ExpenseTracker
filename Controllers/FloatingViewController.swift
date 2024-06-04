//
//  FloatingViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 16/05/2024.
//

import UIKit

class FloatingViewController: UIViewController {
    
   
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return FloatingViewController.createSectionLayout(section: sectionIndex)
        
    })
    
    var  categories: [IncomeCategory] = [
            IncomeCategory(name: "Salary", icon: "briefcase"),
            IncomeCategory(name: "FreeLance", icon: "laptopcomputer"),
            IncomeCategory(name: "Business", icon: "building.columns"),
            IncomeCategory(name: "Gift", icon: "gift"),
            IncomeCategory(name: "Alimony", icon: "figure.2.and.child.holdinghands"),
            IncomeCategory(name: "Dividend", icon: "chart.line.uptrend.xyaxis"),
            IncomeCategory(name: "Royalties", icon: "music.note"),
            IncomeCategory(name: "Rental", icon: "house"),
            IncomeCategory(name: "Grants", icon: "graduationcap"),
            IncomeCategory(name: "Bonuses", icon: "dollarsign"),
           
            
            ]
    
    var  categorie: [ExpenseCategory] = [
            ExpenseCategory(name: "Recurring", icon: "arrow.triangle.2.circlepath"),
            ExpenseCategory(name: "Grocery", icon: "house"),
            ExpenseCategory(name: "Gadgets", icon: "oven"),
            ExpenseCategory(name: "Fuel", icon: "fuelpump"),
            ExpenseCategory(name: "Online", icon: "globe"),
            ExpenseCategory(name: "Shopping", icon: "bag"),
            ExpenseCategory(name: "Net Banking", icon: "building.columns"),
            ExpenseCategory(name: "Food", icon: "fork.knife"),
            ExpenseCategory(name: "Travels", icon: "airplane"),
            ExpenseCategory(name: "Sport", icon: "figure.run"),
            ExpenseCategory(name: "Kids", icon: "figure.and.child.holdinghands"),
            ExpenseCategory(name: "Cinema", icon: "film")
            
            ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
       collectionView.dataSource = self
       collectionView.delegate = self
        collectionView.register(FloatingCollectionViewCell.self, forCellWithReuseIdentifier: FloatingCollectionViewCell.idenrifier)
        collectionView.register(ExpenseFloCollectionViewCell.self, forCellWithReuseIdentifier: ExpenseFloCollectionViewCell.idenrifier)
        collectionView.register(FloatingTitleCollectionViewCell.self, forCellWithReuseIdentifier: FloatingTitleCollectionViewCell.identifier)
        collectionView.register(IncomeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: IncomeCategoryCollectionViewCell.identifier)
        collectionView.register(ExpenseCategoryCollectionViewCell.self, forCellWithReuseIdentifier: ExpenseCategoryCollectionViewCell.identifier)
        
        view.backgroundColor = .systemBackground

        title = "Add Transaction"
    }
    
  

    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
          collectionView.frame = view.bounds
        }
    
    
    public func navigateToItemList() {
        // Instantiate PanelViewController with the provided userAddedItems
        let itemListViewController = Income_ExpenseViewController(categories: categories, categorie: categorie)
        
        navigationController?.pushViewController(itemListViewController, animated: true)
    }
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
      
        switch section {
            
             case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                      
                      let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180)), subitems: [item])
                      let section = NSCollectionLayoutSection(group: group)
                      return section
                      
           
        case 1:
            
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                      
                      let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), subitems: [item])
                      let section = NSCollectionLayoutSection(group: group)
                      return section
            
            
        case 2:
            
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                      
                      let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), subitems: [item])
                      let section = NSCollectionLayoutSection(group: group)
                      return section
        case 3:
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.7)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 8, trailing: 15) // Adjust the insets as needed
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitem: item, count: 4) // Adjust the count as needed
            let section = NSCollectionLayoutSection(group: group)
            
            
            return section
            
        case 4:
            
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


extension FloatingViewController: UICollectionViewDelegate,  UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
            
        case 3:
            let maxItemsToShowInCollectionViewCell = 4
                    return min(categories.count, maxItemsToShowInCollectionViewCell)
        case 4:
            let maxItemsToShowInCollectionViewCell = 4
                    return min(categorie.count, maxItemsToShowInCollectionViewCell)
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FloatingCollectionViewCell.idenrifier, for: indexPath) as?  FloatingCollectionViewCell  else {
                return UICollectionViewCell()
            }
           
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpenseFloCollectionViewCell.idenrifier, for: indexPath) as?  ExpenseFloCollectionViewCell  else {
                return UICollectionViewCell()
            }
           
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FloatingTitleCollectionViewCell.identifier, for: indexPath) as?  FloatingTitleCollectionViewCell  else {
                return UICollectionViewCell()
            }
           
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IncomeCategoryCollectionViewCell.identifier, for: indexPath) as? IncomeCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            let category = categories[indexPath.item]
            cell.configure(with: category)
            return cell
            
        case 4:
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath .section {
        case 0:
            let incomeVC = AddIncomeViewController()
            navigationController?.pushViewController(incomeVC, animated: true)
        case 1:
            let expenseVC = AddExpenseViewController()
            navigationController?.pushViewController(expenseVC, animated: true)
        default:
            break
        }
    }
    
    
    
    
}
