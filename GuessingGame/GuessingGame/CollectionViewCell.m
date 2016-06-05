//
//  CollectionViewCell.m
//  GuessingGame
//
//  Created by Andrea Borghi on 10/28/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)setNeedsDisplay {
    self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.2];
}

- (void)setNumber:(NSNumber *)number {
    self.numberLabel.text = [NSString stringWithFormat:@"%@", number];
}

- (BOOL)containsNumber:(NSNumber *)number {
    if ([self.numberLabel.text integerValue] == [number integerValue]) {
        return true;
    } else {
        return false;
    }
}

@end
