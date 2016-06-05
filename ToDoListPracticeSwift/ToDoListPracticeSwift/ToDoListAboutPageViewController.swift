//
//  ToDoListAboutPageViewController.swift
//  ToDoListPracticeSwift
//
//  Created by Andrea Borghi on 11/16/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import UIKit

class ToDoListAboutPageViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(NSURLRequest(URL: (NSURL(string: "http://en.wikipedia.org/wiki/Grocery_store"))!))
    }
}