//
//  WorldListPopoverDataSource.h
//  ARListPopoverViewController-Demo
//
//  Created by Adrian Russell on 11/08/2014.
//  Copyright (c) 2014 Adrian Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"
#import "ARListPopoverController.h"

/**
 A slightly more complex data source that uses various classes.
 */
@interface WorldListPopoverDataSource : NSObject <ARListPopoverControllerDataSource>

@property (readonly) World *world;

- (id)initWithWorld:(World *)world;

@end
