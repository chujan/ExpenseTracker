//
//  UserExpenseItem.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 16/02/2024.
//

import Foundation
import UIKit
struct UserExpenseItem {
    var amount: String
    var category: String
    var itemName: String
    var time: String
    var date: Date
    
    //var originalDate: Date
    var image: Data?
    let categoryBackgroundColor: UIColor
  
    

    init(amount: String, category: String,  itemName: String,  time: String, date: Date, image: UIImage?, categoryBackgroundColor: UIColor) {
        self.amount = amount
        self.category = category
        self.itemName = itemName
        self.time = time
        self.date = date
       
        self.categoryBackgroundColor = categoryBackgroundColor
        
       

        // Convert UIImage to Data if provided
        self.image = image?.jpegData(compressionQuality: 0.8)
    }

}

