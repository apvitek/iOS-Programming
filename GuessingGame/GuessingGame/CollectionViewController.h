//
//  CollectionViewController.h
//  GuessingGame
//
//  Created by Andrea Borghi on 10/28/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UICollectionViewController

- (void)addNumber:(NSNumber *)number;
- (void)highlightNumberInCollectionView:(NSNumber *)number;
- (void)resetView;

@end
