//
//  ToDoDetailsViewController.h
//  ToDoListPractice
//
//  Created by Andrea Borghi on 10/2/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) UIImage * imageForItem;
@property (nonatomic, strong) NSString * titleForItem;

@end
