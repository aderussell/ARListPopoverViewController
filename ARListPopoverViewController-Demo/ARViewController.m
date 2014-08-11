//
//  ARViewController.m
//  ARListPopoverViewController-Demo
//
//  Created by Adrian Russell on 10/08/2014.
//  Copyright (c) 2014 Adrian Russell. All rights reserved.
//

#import "ARViewController.h"
#import "ARListPopoverController.h"
#import "ARListPopoverControllerSimpleDataSource.h"


#import "World.h"
#import "WorldListPopoverDataSource.h"

@interface ARViewController () <ARListPopoverControllerDelegate>
@property ARListPopoverController *listPopover;

@property ARListPopoverControllerSimpleDataSource *simpleDataSource;
@property WorldListPopoverDataSource *complexDataSource;

@property IBOutlet UISwitch *onlyOutputAtEndOfStructure;
@property IBOutlet UILabel  *output;

@end

@implementation ARViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create the data sources for the list popover.
    self.simpleDataSource  = [self createSimpleStructure];
    self.complexDataSource = [self createComplexStructure];
}


#pragma mark - ARListPopoverController Delegate Methods

- (void)listPopoverController:(ARListPopoverController *)listPopover didSelectItem:(id)item
{
    
    
    if ([listPopover.dataSource isKindOfClass:[ARListPopoverControllerSimpleDataSource class]]) {
        
        
        ARListPopoverControllerSimpleDataSource *dataSource = (ARListPopoverControllerSimpleDataSource *)listPopover.dataSource;
        
        // this shows an example where it doesn't do anything unless the selected item is the final part of a path and can't be expanded
        if (self.onlyOutputAtEndOfStructure.isOn && [dataSource listPopoverController:listPopover itemIsExpandable:item]) {
            return;
        }
        
        
        NSIndexPath *indexPath = [listPopover indexPathForSelectedItem];
        
        NSArray *titles = [dataSource titlesForObjectsAlongIndexPath:indexPath];
        
        NSLog(@"titles: %@", [dataSource titlesForObjectsAlongIndexPath:indexPath]);
        
        self.output.text = [titles componentsJoinedByString:@"\n"];
        
    } else {
        // just print out the last item name
        self.output.text = [item name];
    }
}


#pragma mark - IBActions

- (IBAction)showListPopover:(id)sender
{
    ARListPopoverController *popover = [[ARListPopoverController alloc] initWithDataSource:self.simpleDataSource];
    self.listPopover = popover;
    popover.delegate = self;
    [popover presentPopoverFromRect:[sender frame] inView:[sender superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.output.text = nil;
}

- (IBAction)showComplexStructureList:(id)sender
{
    ARListPopoverController *popover = [[ARListPopoverController alloc] initWithDataSource:self.complexDataSource];
    self.listPopover = popover;
    popover.delegate = self;
    [popover presentPopoverFromRect:[sender frame] inView:[sender superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.output.text = nil;
}

#pragma mark - Create Data Source Objects

- (ARListPopoverControllerSimpleDataSource *)createSimpleStructure
{
    NSArray *contents =  @[ @{ @"North America" : @[@"United States of America",
                                       @"Canada",
                                       @"Mexico"] },
               @{ @"South America" : @[@"Brazil",
                                       @"Argentina",
                                       @"Peru",
                                       @"Chile"] },
               @{ @"Europe" : @[@"France",
                                @"Germany",
                                @{ @"United Kingdom": @[@"London",
                                                        @"Plymouth",
                                                        @"Coventry"] } ] },
               @{ @"Africa" : @[@"Eygpt",
                                @"Nigeria",
                                @"South Africa",
                                @"Libya",
                                @"Algeria",
                                @"Angola" ] },
               @{ @"Asia" : @[@"China",
                              @"Japan",
                              @"Vietnam"] },
               @{ @"Australia" : @[@"Austrailia",
                                   @"Tasmania",
                                   @"New Guinea"] },
               @"Antarctica"
               ];
    
    
    return [[ARListPopoverControllerSimpleDataSource alloc] initWithMainTitle:@"World" contentsStructure:contents];
}


- (WorldListPopoverDataSource *)createComplexStructure
{
    
    Country *usa    = [[Country alloc] initWithName:@"United States of America" flag:[UIImage imageNamed:@"flag-usa.png"]];
    Country *canada = [[Country alloc] initWithName:@"Canada"];
    Country *mexico = [[Country alloc] initWithName:@"Mexico"];
    
    County *nevada     = [[County alloc] initWithName:@"Nevada"];
    County *newYork    = [[County alloc] initWithName:@"New York"];
    County *california = [[County alloc] initWithName:@"California"];
    [usa.counties addObject:nevada];
    [usa.counties addObject:newYork];
    [usa.counties addObject:california];
    
    Continent *northAmerica = [[Continent alloc] initWithName:@"North America"];
    [northAmerica.countries addObject:usa];
    [northAmerica.countries addObject:canada];
    [northAmerica.countries addObject:mexico];
    
    
    World *world = [World new];
    [world.continents addObject:northAmerica];
    
    
    return [[WorldListPopoverDataSource alloc] initWithWorld:world];
}


@end
