//
//  Continent.h
//  ARListPopoverViewController-Demo
//
//  Created by Adrian Russell on 11/08/2014.
//  Copyright (c) 2014 Adrian Russell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Town : NSObject
@property (readonly) NSString *name;
- (instancetype)initWithName:(NSString *)name;
@end

@interface County : NSObject
@property (readonly) NSString *name;
@property (readonly) NSMutableArray  *towns;
- (instancetype)initWithName:(NSString *)name;
@end

@interface Country : NSObject
@property (readonly) NSString *name;
@property (readonly) UIImage  *flag;
@property (readonly) NSMutableArray  *counties;
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name flag:(UIImage *)flag;
@end

@interface Continent : NSObject
@property (readonly) NSString *name;
@property (readonly) NSMutableArray  *countries;
- (instancetype)initWithName:(NSString *)name;
@end


@interface World : NSObject
@property (readonly) NSMutableArray *continents;
@end