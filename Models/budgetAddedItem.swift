//
//  budgetAddedItem.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 08/04/2024.
//

import Foundation
import UIKit

struct budgetAddedItem {
    var amount: String
    var category: String
    var image: Data?
    var date: Date
    let categoryBackgroundColor: UIColor
    
    
    init(amount: String, category: String,   image: UIImage?, categoryBackgroundColor: UIColor, date: Date) {
        self.amount = amount
        self.category = category
      
       
        self.categoryBackgroundColor = categoryBackgroundColor
        
        self.date = date

        // Convert UIImage to Data if provided
        self.image = image?.jpegData(compressionQuality: 0.8)
    }

}
