//
//  ToDoListItem.swift
//  ToDoListPracticeSwift
//
//  Created by Andrea Borghi on 11/13/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class ToDoListItem {
    var itemTitle: String
    var itemDescription: String
    var itemImage: UIImage?
    var itemInfo: String
    var checked: Bool = false
    var quantity: Int
    
    init(title: String, description: String, image: UIImage?, info: String, quantity: Int) {
        self.itemTitle = title
        self.itemDescription = description
        if image != nil {
            self.itemImage = image
        }
        self.itemInfo = info
        self.quantity = quantity
    }
}