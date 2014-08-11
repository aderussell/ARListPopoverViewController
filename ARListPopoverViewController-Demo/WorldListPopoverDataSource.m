//
//  WorldListPopoverDataSource.m
//  ARListPopoverViewController-Demo
//
//  Created by Adrian Russell on 11/08/2014.
//  Copyright (c) 2014 Adrian Russell. All rights reserved.
//

#import "WorldListPopoverDataSource.h"

@implementation WorldListPopoverDataSource

- (id)initWithWorld:(World *)world
{
    if (self = [super init]) {
        _world = world;
    }
    return self;
}



- (NSString *)listPopoverController:(ARListPopoverController *)listPopover titleForItem:(id)item
{
    if (item == nil) {
        return @"World";
    } else if ([item isKindOfClass:[Continent class]]) {
        return [item name];
    } else if ([item isKindOfClass:[Country class]]) {
        return [item name];
    } else if ([item isKindOfClass:[County class]]) {
        return [item name];
    } else if ([item isKindOfClass:[Town class]]) {
        return [item name];
    } else {
        return nil;
    }
}

- (NSUInteger)listPopoverController:(ARListPopoverController *)listPopover numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return self.world.continents.count;
    } else if ([item isKindOfClass:[Continent class]]) {
        Continent *continent = (Continent *)item;
        return continent.countries.count;
    } else if ([item isKindOfClass:[Country class]]) {
        Country *country = (Country *)item;
        return country.counties.count;
    } else if ([item isKindOfClass:[County class]]) {
        County *county = (County *)item;
        return county.towns.count;
    } else if ([item isKindOfClass:[Town class]]) {
        return 0;
    } else {
        return 0;
    }
}

- (id)listPopoverController:(ARListPopoverController *)listPopover childForIndex:(NSUInteger)index ofItem:(id)item
{
    if (item == nil) {
        return self.world.continents[index];
    } else if ([item isKindOfClass:[Continent class]]) {
        Continent *continent = (Continent *)item;
        return continent.countries[index];
    } else if ([item isKindOfClass:[Country class]]) {
        Country *country = (Country *)item;
        return country.counties[index];
    } else if ([item isKindOfClass:[County class]]) {
        County *county = (County *)item;
        return county.towns[index];
    } else if ([item isKindOfClass:[Town class]]) {
        return nil;
    } else {
        return nil;
    }
}


- (BOOL)listPopoverController:(ARListPopoverController *)listPopover itemIsExpandable:(id)item
{
    return ([self listPopoverController:listPopover numberOfChildrenOfItem:item] > 0);
}

- (UIImage *)listPopoverController:(ARListPopoverController *)listPopover imageForItem:(id)item
{
    if ([item isKindOfClass:[Country class]]) {
        Country *country = (Country *)item;
        return country.flag;
    }
    return nil;
}

@end
