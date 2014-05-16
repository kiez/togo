//
//  K2GFSLocation.h
//  Kiez ToGo
//
//  Created by Christian Beer on 16.05.14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface K2GFSLocation : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *cc;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *crossStreet;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) CLLocationCoordinate2D location;

- (instancetype) initWithFoursquareDictionary:(NSDictionary*)dict;

@end
