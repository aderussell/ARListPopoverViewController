//
//  ARListPopoverControllerSimpleDataSource.m
//  ARListPopoverViewController-Demo
//
//  Created by Adrian Russell on 10/08/2014.
//  Copyright (c) 2014 Adrian Russell. All rights reserved.
//

#import "ARListPopoverControllerSimpleDataSource.h"

@implementation ARListPopoverControllerSimpleDataSource

- (id)initWithStructure:(NSDictionary *)structure
{
    if (self = [super init]) {
        _structure = structure;
    }
    return self;
}

- (instancetype)initWithMainTitle:(NSString *)title contentsStructure:(NSArray *)array
{
    return [self initWithStructure:@{title : array}];
}

//-------------------------------------------------------------------------------------//
#pragma mark - Stuffs

- (NSArray *)topArray
{
    return self.structure[[self.structure allKeys][0]];
}

- (NSArray *)titlesForObjectsAlongIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:indexPath.length];
    
    NSArray *currentLevel = [self topArray];
    for (NSUInteger i = 0; i < indexPath.length; i++) {
        
        id obj = currentLevel[[indexPath indexAtPosition:i]];
        
        if ([obj isKindOfClass:[NSString class]]) {
            [titles addObject:obj];
            break;
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)obj;
            NSString *key = [dict allKeys][0];
            [titles addObject:key];
            currentLevel = dict[key];
        } else {
            break;
        }
    }
    
    return [titles copy];
}



//--------------------------------------------------------------------------------------//

// newStuff

- (id)listPopoverController:(ARListPopoverController *)listPopover childForIndex:(NSUInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [self topArray][index];
        
    } else if ([item isKindOfClass:[NSString class]]) {
        return nil;
    } else if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)item;
        NSString *key = [dictionary allKeys][0];
        NSArray *subArray = dictionary[key];
        return subArray[index];
    }
    return nil;
}



- (NSString *)listPopoverController:(ARListPopoverController *)listPopover titleForItem:(id)item
{
    if (item == nil) {
        return [self.structure allKeys][0];
    } else if ([item isKindOfClass:[NSString class]]) {
        return item;
    } else if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)item;
        NSString *key = [dictionary allKeys][0];
        return key;
    }
    return nil;
}

- (NSUInteger)listPopoverController:(ARListPopoverController *)listPopover numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self topArray].count;
        
    } else if ([item isKindOfClass:[NSString class]]) {
        return 0;
    } else if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)item;
        NSString *key = [dictionary allKeys][0];
        NSArray *subArray = dictionary[key];
        return subArray.count;
    }
    return 0;
}

- (BOOL)listPopoverController:(ARListPopoverController *)listPopover itemIsExpandable:(id)item
{
    return ([self listPopoverController:listPopover numberOfChildrenOfItem:item] > 0);
}


@end
