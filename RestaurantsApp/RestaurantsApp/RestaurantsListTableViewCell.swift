//
//  RestaurantsListTableViewCell.swift
//  RestaurantsApp
//
//  Created by Andrea Borghi on 11/28/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import UIKit

class RestaurantsListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
