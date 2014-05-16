//
//  K2GFSVenue.m
//  Kiez ToGo
//
//  Created by Christian Beer on 16.05.14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "K2GFSVenue.h"

#import "K2GFSLocation.h"

@implementation K2GFSVenue

- (instancetype) initWithFoursquareDictionary:(NSDictionary*)dict;
{
    self = [super init];

    self.identifier = dict[@"id"];
    self.name = dict[@"name"];
    self.contact = dict[@"contact"];
    self.location = [[K2GFSLocation alloc] initWithFoursquareDictionary:dict[@"location"]];
    self.rating = dict[@"rating"] ? [dict[@"rating"] floatValue] : MAXFLOAT;
    
    NSArray *categories = dict[@"categories"];
    NSArray *primaryCategories = [categories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"primary == 1"]];
    self.primaryCategoryName = [[primaryCategories firstObject] valueForKeyPath:@"name"];
    
    // more fields skipped for now
    
    return self;
}

@end
