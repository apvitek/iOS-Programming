//
//  ViewController.swift
//  StringApp_AB
//
//  Created by Andrea Borghi on 10/29/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userInputField: UITextField!
    @IBOutlet weak var programOutput: UITextView!
    @IBOutlet weak var palindromePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitInputButtonPressed(sender: AnyObject) {
        if userInputField.isFirstResponder() {
            userInputField.resignFirstResponder()
        }
        
        let userInput = userInputField.text
        
        let results = userInput.analyzeString()
        
        programOutput.text = "The string contains:\n\n- \(countElements(userInput)) characters.\n- \(results.uppercase) uppercase letters.\n- \(results.lowercase) lowercase letters.\n- \(results.numerals) numerals.\n- \(results.nonAlpha) non alphanumeric characters."
        
        programOutput.text! += "\n\nThe reversed string is \"\(userInput.reversedString)\"."
        
        if userInput.isPalindrome == true {
            programOutput.text! += "\nThe string is also palindrome."
            palindromePicture.image = UIImage(named: "palindrome2")
            palindromePicture.alpha = 0.0
            UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
                self.palindromePicture.alpha = 1.0
                }, completion:{ (isCompleted) -> Void in
                    UIView.animateWithDuration(1.5, delay: 1.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
                        self.palindromePicture.alpha = 0.0
                        }, completion:nil)
            })
        } else {
            programOutput.text! += "\nThe string is NOT palindrome."
        }
    }
}

