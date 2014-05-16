//
//  K2GFSLocation.m
//  Kiez ToGo
//
//  Created by Christian Beer on 16.05.14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "K2GFSLocation.h"

@implementation K2GFSLocation

- (instancetype) initWithFoursquareDictionary:(NSDictionary*)dict;
{
    self = [super init];
    
    self.address = dict[@"address"];
    self.cc = dict[@"cc"];
    self.city = dict[@"city"];
    self.country = dict[@"country"];
    self.crossStreet = dict[@"crossStreet"];
    self.distance = [dict[@"distance"] intValue];
    
    NSString *lat = dict[@"lat"];
    NSString *lng = dict[@"lng"];
    self.location = CLLocationCoordinate2DMake(lat.floatValue, lng.floatValue);
    
    return self;
}

@end
