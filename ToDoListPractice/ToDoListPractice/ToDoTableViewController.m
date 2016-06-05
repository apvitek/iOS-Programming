//
//  ToDoTableViewController.m
//  ToDoListPractice
//
//  Created by Andrea Borghi on 10/1/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import "ToDoTableViewController.h"
#import "ToDoTableViewDataSource.h"
#import "ToDoDetailsViewController.h"
#import "ToDoTableViewCell.h"

@interface ToDoTableViewController ()

@property (strong, nonatomic) ToDoTableViewDataSource * dataSource;

@end

@implementation ToDoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.dataSource) {
        self.dataSource = [[ToDoTableViewDataSource alloc] init];
        self.tableView.dataSource = self.dataSource;
        self.tableView.delegate = self.dataSource;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        ToDoTableViewCell * senderCell = (ToDoTableViewCell *)sender;
        ToDoDetailsViewController * detailsView = segue.destinationViewController;
        detailsView.imageForItem = senderCell.accessoryImage.image;
        NSString * title = senderCell.titleLabel.text;
        title = [title stringByAppendingString:@" - "];
        detailsView.titleForItem = [title stringByAppendingString:senderCell.subtitleLabel.text];
    }
}

@end
