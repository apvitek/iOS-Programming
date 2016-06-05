//
//  ToDoSearchResultCell.swift
//  ToDoListPracticeSwift
//
//  Created by Andrea Borghi on 11/15/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import UIKit

class ToDoSearchResultCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemPictureView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
