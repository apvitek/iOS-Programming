//
//  CollectionViewController.m
//  GuessingGame
//
//  Created by Andrea Borghi on 10/28/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"

@interface CollectionViewController ()

@property (nonatomic, strong) NSMutableArray * numbersArray;
@property (nonatomic, strong) NSMutableArray * modifiedCells;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = nil;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self populateNumbersArray];
}

- (void)populateNumbersArray {
    for (int i = 1; i <= 100; ++i) {
        [self.numbersArray addObject:[NSNumber numberWithInt:i]];
    }
}

- (NSMutableArray *)numbersArray {
    if (!_numbersArray) {
        self.numbersArray = [[NSMutableArray alloc] init];
    }
    
    return _numbersArray;
}

- (NSMutableArray *)modifiedCells {
    if (!_modifiedCells) {
        self.modifiedCells = [[NSMutableArray alloc] init];
    }
    
    return _modifiedCells;
}

- (void)addNumber:(NSNumber *)number {
    NSArray * newData = [[NSArray alloc] initWithObjects:number, nil];
    [self.collectionView performBatchUpdates:^{
        int resultsSize = (int)[self.numbersArray count]; //data is the previous array of data
        [self.numbersArray addObjectsFromArray:newData];
        NSMutableArray * arrayWithIndexPaths = [NSMutableArray array];
        for (int i = resultsSize; i < resultsSize + newData.count; i++)
        {
            [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
    }
                                  completion:nil];
}

- (void)highlightNumberInCollectionView:(NSNumber *)number {
    NSIndexPath * path;
    
    for (CollectionViewCell * cell in self.collectionView.visibleCells) {
        if ([cell containsNumber:number]) {
            path = [self.collectionView indexPathForCell:cell];
            [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
                cell.numberLabel.textColor = [UIColor blueColor];
                cell.alpha = 0.3;
                [self.modifiedCells addObject:cell];
            } completion:nil];
            break;
        }
    }
}

- (void)resetView {
    for (CollectionViewCell * cell in self.modifiedCells) {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            cell.numberLabel.textColor = [UIColor redColor];
            cell.alpha = 1.0;
        } completion:nil];
    }
    
    [self.modifiedCells removeAllObjects];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numbersArray.count;
}

- (CollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellIdentifier = @"CollectionViewCell";
    
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[CollectionViewCell alloc] init];
    }
    
    cell.number = [self.numbersArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat cellSpacing = ((UICollectionViewFlowLayout *) collectionViewLayout).minimumLineSpacing;
    CGFloat cellWidth = ((UICollectionViewFlowLayout *) collectionViewLayout).itemSize.width;
    NSInteger cellCount = [collectionView numberOfItemsInSection:section] / 10;
    CGFloat inset = (collectionView.bounds.size.width - (cellCount * (cellWidth + cellSpacing))) * 0.5;
    inset = MAX(inset, 0.0);
    return UIEdgeInsetsMake(inset, inset, inset, inset);
}

@end
