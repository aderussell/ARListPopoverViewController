//
//  ARListPopoverController.h
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

@import UIKit;
@class ARListPopoverController;

#pragma mark ARListPopoverController Delegate

/**
 The delegate protocol. An object should adopt this protocol to recieve event notifications for an ARListPopoverController.
 */
@protocol ARListPopoverControllerDelegate <UIPopoverControllerDelegate>
@optional

/** 
 Tells the delegate that an item has been in the specified list popover.
 @param listPopover The list popover controller where an item was selected.
 @param item        The item that was selected in the popover controller.
 */
- (void)listPopoverController:(ARListPopoverController *)listPopover didSelectItem:(id)item;

@end


#pragma mark - ARListPopoverController Data Source

/**
 The data source protocol. An object should adopt this protocol to provide the data to be displayed in an ARListPopoverController.
 */
@protocol ARListPopoverControllerDataSource <NSObject>
@required

/**
 Returns the child item at the specified index of a given item.
 @param listPopover The list popover controller that sent the message.
 @param index       The index of the child item to return.
 @param item        An item in the data source.
 @return The child item at index of a item. If item is nil, returns the appropriate child item of the root object.
 */
- (id)listPopoverController:(ARListPopoverController *)listPopover childForIndex:(NSUInteger)index ofItem:(id)item;

/**
 Returns the title for a given item that will displayed in the list popover controller.
 @param listPopover The list popover controller that sent the message.
 @param item        An item in the data source.
 @return The title for a given item that will displayed in the list popover controller. If the item is nil,  returns a title for the root item.
 */
- (NSString *)listPopoverController:(ARListPopoverController *)listPopover titleForItem:(id)item;

/**
 Returns the number of child items encompassed by a given item.
 @param listPopover The list popover controller that sent the message.
 @param item        An item in the data source.
 @return The number of child items encompassed by item. If item is nil, this method should return the number of children for the top-level item.
 */
- (NSUInteger)listPopoverController:(ARListPopoverController *)listPopover numberOfChildrenOfItem:(id)item;

/**
 Returns a Boolean value that inidicates whether the given item can be expanded to display children.
 @param listPopover The list popover controller that sent the message.
 @param item        An item in the data source.
 @return `YES` if the item can be expanded when selected and display children from it, otherwise `NO`.
 @discussion This method may be called quite often, so it must be efficient.
 */
- (BOOL)listPopoverController:(ARListPopoverController *)listPopover itemIsExpandable:(id)item;

@optional

/**
 Returns an image for a given item that will displayed in the list popover controller.
 @param listPopover The list popover controller that sent the message.
 @param item        An item in the data source.
 @return An image for a given item that will displayed in the list popover controller.
 */
- (UIImage *)listPopoverController:(ARListPopoverController *)listPopover imageForItem:(id)item;

@end


#pragma mark - ARListPopoverController

/**
 A UIPopoverController that can display nested information in a UITableView manner.
 */
@interface ARListPopoverController : UIPopoverController

/**
 Creates a new list popover controller using the specified data source.
 @param dataSource The object that will act as the data source for the list popover controller.
 @return A new `ARLisrPopoverController` object.
 */
- (instancetype)initWithDataSource:(id<ARListPopoverControllerDataSource>)dataSource;

/** The object that acts as data source for the recieving list popover controller.
 @discussion The data source must adopt the `ARListPopoverControllerDataSource` protocol. The data source is not retained.
 */
@property (nonatomic, readonly, weak) id<ARListPopoverControllerDataSource>dataSource;

/** The object that acts as the delegate for the receiving list popover controller.
 @discussion The delegate must adopt the `ARListPopoverControllerDelegate` protocol. The delegate is not retained.
 */
@property (nonatomic, weak) id<ARListPopoverControllerDelegate> delegate;

/** The index path to the currently selected item in the receiving list popover controller.
 @discussion If no item in the current contents is selected then the returned indexpath will be to the current contents.
 */
- (NSIndexPath *)indexPathForSelectedItem;

@end
