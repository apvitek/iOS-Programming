//
//  ToDoTableViewCell.h
//  ToDoListPractice
//
//  Created by Andrea Borghi on 10/1/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *accessoryImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
