//
//  ToDoListDetailViewController.swift
//  ToDoListPracticeSwift
//
//  Created by Andrea Borghi on 10/8/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class ToDoListDetailViewController: UIViewController {
    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var itemTitle: String?
    var itemSubtitle: String?
    var itemPicture: UIImage?
    var itemInfo: String?
    var itemQuantity: Int?
    let standardLabelText = "Unknown"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItemPictureLayer()
        
        if itemTitle != nil {
            detailsTitleLabel.text = itemTitle
        } else {
            detailsTitleLabel.text = standardLabelText
        }
        
        if itemSubtitle != nil {
            subtitleLabel.text = itemSubtitle
        } else {
            subtitleLabel.text = standardLabelText
        }
        
        if itemPicture != nil {
            detailsImageView.image = itemPicture
        } else {
            detailsImageView.backgroundColor = UIColor.blueColor()
            detailsImageView.alpha = 0.5
        }
        
        if itemInfo != nil {
            textView.text = itemInfo
        } else {
            textView.text = standardLabelText
        }
        
        if itemQuantity != nil {
            quantityLabel.text = "\(itemQuantity!)"
        } else {
            quantityLabel.alpha = 0.0
        }
    }
    
    func setupItemPictureLayer() {
        var layer = detailsImageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = detailsImageView.frame.size.width / 6
        layer.borderWidth = 4
        layer.borderColor = UIColor(red:(179.0/255.0), green:(179.0/255.0), blue:(179.0/255.0), alpha:(0.3)).CGColor
    }
}