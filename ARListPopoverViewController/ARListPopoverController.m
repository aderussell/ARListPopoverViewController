//
//  ARListPopoverController.m
//
//  Created by Adrian Russell on 30/08/2013.
//  Copyright (c) 2014 Adrian Russell. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#import "ARListPopoverController.h"
#import <objc/runtime.h>

#pragma mark - UITableView Addition

// this provides an additional property to UITableView that will be used in ARListPopoverController to store the item object that is being displayed.
@interface UITableView (AROwnerItem)
@property (nonatomic, strong) id owner;
@end

@implementation UITableView (AROwnerItem)
static char defaultOwnerKey;
- (id)owner
{
    return objc_getAssociatedObject(self, &defaultOwnerKey);
}
- (void)setOwner:(id)owner
{
    objc_setAssociatedObject(self, &defaultOwnerKey, owner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end






#pragma mark - ARListPopoverController Implementation

@interface ARListPopoverController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
@property NSIndexPath *currentIndexPath;
@end


@implementation ARListPopoverController

- (id)initWithDataSource:(id<ARListPopoverControllerDataSource>)dataSource
{
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    
    if (self = [super initWithContentViewController:navi]) {
        _dataSource = dataSource;
        navi.delegate = self;
        tableViewController.tableView.delegate   = self;
        tableViewController.tableView.dataSource = self;
        self.currentIndexPath = [NSIndexPath new];
        tableViewController.title = [self.dataSource listPopoverController:self titleForItem:nil];
        tableViewController.tableView.owner = nil;
    }
    return self;
}


- (NSIndexPath *)indexPathForSelectedItem
{
    return self.currentIndexPath;
}

//-------------------------------------------------------------------------------------//
#pragma mark - UINavigationController delegate methods

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    CGSize size = self.popoverContentSize;
    size.height -= navigationController.navigationBar.frame.size.height;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        viewController.contentSizeForViewInPopover = size;
#pragma clang diagnostic pop
    } else {
        viewController.preferredContentSize = size;
    }
    
    if (navigationController.viewControllers.count == self.currentIndexPath.length) {
        self.currentIndexPath = [self.currentIndexPath indexPathByRemovingLastIndex];
    }
}

//-------------------------------------------------------------------------------------//
#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // add the selected row to the index path and set as new current index path.
    NSIndexPath *nextIndexPath = [self.currentIndexPath indexPathByAddingIndex:indexPath.row];
    self.currentIndexPath = nextIndexPath;
    
    // get the item for the selected cell
    id child = [self.dataSource listPopoverController:self childForIndex:indexPath.row ofItem:tableView.owner];
    
    
    // message the delegate that item was selected
    if ([self.delegate respondsToSelector:@selector(listPopoverController:didSelectItem:)]) {
        [self.delegate listPopoverController:self didSelectItem:child];
    }
    
    // if the item can be expanded them make a new uitableviewcontroller for its children and push it to the navigation controller.
    if ([self.dataSource listPopoverController:self itemIsExpandable:child]) {
        
        // title to display on top of the view controller
        NSString *nextTitle = [self.dataSource listPopoverController:self titleForItem:child];
        
        UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        tableViewController.title = nextTitle;
        tableViewController.tableView.delegate = self;
        tableViewController.tableView.dataSource = self;
        tableViewController.tableView.owner = child;
        
        UINavigationController *navi = (UINavigationController *)[self contentViewController];
        
        CGSize size = self.popoverContentSize;
        size.height -= navi.navigationBar.frame.size.height;
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tableViewController.contentSizeForViewInPopover = size;
#pragma clang diagnostic pop
        } else {
            tableViewController.preferredContentSize = size;
        }
        
        [navi pushViewController:tableViewController animated:YES];
        
    } else {
        // if the item can't be expanded then dismiss the popover
        [self dismissPopoverAnimated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource listPopoverController:self numberOfChildrenOfItem:tableView.owner];
}

//-------------------------------------------------------------------------------------//
#pragma mark - UITableView data source methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // create a table cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // get the item that the cell is for
    id item = [self.dataSource listPopoverController:self childForIndex:indexPath.row ofItem:tableView.owner];
    
    // set the title for the cell
    cell.textLabel.text = [self.dataSource listPopoverController:self titleForItem:item];

    
    // add image if there is one
    if ([self.dataSource respondsToSelector:@selector(listPopoverController:imageForItem:)]) {
        UIImage *image = [self.dataSource listPopoverController:self imageForItem:item];
        cell.imageView.image = image;
    }
    
    // if the item for the cell can be expanded then add a discolure indicator to the cell
    cell.accessoryType = ([self.dataSource listPopoverController:self itemIsExpandable:item]) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    return cell;
}

@end
