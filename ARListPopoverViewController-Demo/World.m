//
//  Continent.m
//  ARListPopoverViewController-Demo
//
//  Created by Adrian Russell on 11/08/2014.
//  Copyright (c) 2014 Adrian Russell. All rights reserved.
//

#import "World.h"

@implementation Town

- (id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

@end

@implementation County

- (id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _name = name;
        _towns = [NSMutableArray new];
    }
    return self;
}

@end


@implementation Country

- (instancetype)initWithName:(NSString *)name
{
    return [self initWithName:name flag:nil];
}

- (id)initWithName:(NSString *)name flag:(UIImage *)flag
{
    if (self = [super init]) {
        _name = name;
        _flag = flag;
        _counties = [NSMutableArray new];
    }
    return self;
}

@end


@implementation Continent

- (id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _name = name;
        _countries = [NSMutableArray new];
    }
    return self;
}

@end

@implementation World

- (id)init
{
    if (self = [super init]) {
        _continents = [NSMutableArray new];
    }
    return self;
}

@end
