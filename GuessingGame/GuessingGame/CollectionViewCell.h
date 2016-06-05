//
//  CollectionViewCell.h
//  GuessingGame
//
//  Created by Andrea Borghi on 10/28/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, weak) NSNumber * number;

- (BOOL)containsNumber:(NSNumber *)number;

@end
