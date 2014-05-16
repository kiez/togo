//
//  K2GFoursquareManager.h
//  Kiez ToGo
//
//  Created by Christian Beer on 16.05.14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void(^K2GFoursquareVenuesResultHandler)(BOOL success, id result);

@interface K2GFoursquareManager : NSObject

+ (instancetype) sharedInstance;
- (void) setupFoursquare;
- (void) requestVenuesAround:(CLLocationCoordinate2D)coordinate handler:(K2GFoursquareVenuesResultHandler)handler;

- (BOOL) handleURL:(NSURL*)url;

@end
