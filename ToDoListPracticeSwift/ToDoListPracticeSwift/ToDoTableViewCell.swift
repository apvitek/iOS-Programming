//
//  ToDoTableViewCell.swift
//  ToDoListPracticeSwift
//
//  Created by Andrea Borghi on 10/3/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class ToDoTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var itemPictureView: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func awakeFromNib() {
        setupItemPictureLayer()
    }
    
    func setupItemPictureLayer() {
        var layer = itemPictureView.layer
        layer.masksToBounds = true
        layer.cornerRadius = itemPictureView.frame.size.width / 2
        layer.borderWidth = 4
        layer.borderColor = UIColor(red:(179.0/255.0), green:(179.0/255.0), blue:(179.0/255.0), alpha:(0.3)).CGColor
    }
}