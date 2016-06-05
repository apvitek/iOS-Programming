//
//  ToDoTableViewDataSource.m
//  ToDoListPractice
//
//  Created by Andrea Borghi on 10/2/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import "ToDoTableViewDataSource.h"
#import "ToDoTableViewCell.h"

@interface ToDoTableViewDataSource ()

@property (nonatomic, strong) NSMutableArray * titleList;
@property (nonatomic, strong) NSMutableArray * descriptionList;
@property (nonatomic, strong) NSMutableArray * imagesNamesList;
@property (nonatomic, strong) NSMutableArray * imagesList;
@property (nonatomic, strong) NSMutableArray * checkedItems;

@end

@implementation ToDoTableViewDataSource

- (instancetype)init
{
    [self getDataFromPlist];
    self.checkedItems = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.titleList.count; ++i) {
        [self.checkedItems addObject:[NSNumber numberWithBool:FALSE]];
    }
    
    return self;
}

- (void)getDataFromPlist
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    NSDictionary * dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    self.titleList = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"ItemTitle"]];
    self.descriptionList = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"ItemDescription"]];
    self.imagesNamesList = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"ItemImage"]];
    
    if (!self.imagesList) {
        self.imagesList = [[NSMutableArray alloc] init];
    }
    
    for (NSString * imageName in self.imagesNamesList) {
        [self.imagesList addObject:[UIImage imageNamed:imageName]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier = @"CustomCell";
    ToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[ToDoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    cell.titleLabel.text = [self.titleList objectAtIndex:indexPath.row];
    cell.subtitleLabel.text = [self.descriptionList objectAtIndex:indexPath.row];
    cell.accessoryImage.image = [self.imagesList objectAtIndex:indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([[self.checkedItems objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithBool:TRUE]]) {
        [self.checkedItems replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:FALSE]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [self.checkedItems replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:TRUE]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.titleList removeObjectAtIndex:indexPath.row];
    [self.descriptionList removeObjectAtIndex:indexPath.row];
    [self.imagesList removeObjectAtIndex:indexPath.row];
    [self.imagesNamesList removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [tableView endUpdates];
}

@end
