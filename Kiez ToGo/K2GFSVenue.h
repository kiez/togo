//
//  K2GFSVenue.h
//  Kiez ToGo
//
//  Created by Christian Beer on 16.05.14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import <Foundation/Foundation.h>

@class K2GFSLocation;

@interface K2GFSVenue : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDictionary *contact;
@property (nonatomic, strong) K2GFSLocation *location;

@property (nonatomic, copy) NSString *primaryCategoryName;

- (instancetype) initWithFoursquareDictionary:(NSDictionary*)dict;

@end
