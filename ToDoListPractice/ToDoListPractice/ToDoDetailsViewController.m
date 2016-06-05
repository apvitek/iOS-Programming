//
//  ToDoDetailsViewController.m
//  ToDoListPractice
//
//  Created by Andrea Borghi on 10/2/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import "ToDoDetailsViewController.h"

@interface ToDoDetailsViewController ()

@end

@implementation ToDoDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.imageForItem != nil) {
        self.imageView.image = self.imageForItem;
    }
    
    if (self.titleForItem != nil) {
        self.descriptionLabel.text = self.titleForItem;
    }
}

@end
