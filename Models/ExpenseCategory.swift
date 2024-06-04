//
//  ExpenseCategory.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 12/02/2024.
//

import Foundation
import UIKit
struct ExpenseCategory {
    var name: String
    var icon: String?
    var amount: String?
    var color: UIColor?
    var time: String?
    var subcategories: [ExpenseCategory]?

    init(name: String, icon: String? = nil, color: UIColor? = nil, subcategories: [ExpenseCategory]? = nil, amount: String? = nil, time: String? = nil) {
        self.name = name
        self.icon = icon
        self.color = color
        self.amount = amount
        self.time = time
        self.subcategories = subcategories
    }
}
