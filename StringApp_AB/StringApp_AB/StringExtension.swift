//
//  StringExtension.swift
//  StringApp_AB
//
//  Created by Andrea Borghi on 11/3/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation

extension String {
    func analyzeString() -> (uppercase: Int, lowercase: Int, numerals: Int, nonAlpha: Int) {
        var uppercaseLetters = 0
        var lowercaseLetters = 0
        var numerals = 0
        var nonAlpha = 0
        
        for character in self {
            switch character {
            case "a"..."z":
                lowercaseLetters++
            case "A"..."Z":
                uppercaseLetters++
            case "0"..."9":
                numerals++
            default:
                nonAlpha++
            }
        }
        
        return (uppercaseLetters, lowercaseLetters, numerals, nonAlpha)
    }
    
    var reversedString: String {
        return String(reverse(self))
    }
    
    var isPalindrome: Bool {
        if self.reversedString.lowercaseString == self.lowercaseString {
            return true
        } else {
            return false
        }
    }
}