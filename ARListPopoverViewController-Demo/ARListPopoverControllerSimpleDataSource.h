//
//  ARListPopoverControllerSimpleDataSource.h
//  ARListPopoverViewController-Demo
//
//  Created by Adrian Russell on 10/08/2014.
//  Copyright (c) 2014 Adrian Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARListPopoverController.h"

/**
 A simple data source object for a ARListPopoverController that takes in a dictionary of dictionaries containing for items.
 */
@interface ARListPopoverControllerSimpleDataSource : NSObject <ARListPopoverControllerDataSource>

- (instancetype)initWithStructure:(NSDictionary *)structure;

- (instancetype)initWithMainTitle:(NSString *)title contentsStructure:(NSArray *)array;

@property (readonly) NSDictionary *structure;


- (NSArray *)titlesForObjectsAlongIndexPath:(NSIndexPath *)indexPath;

@end
