//
//  K2GFoursquareManager.m
//  Kiez ToGo
//
//  Created by Christian Beer on 16.05.14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "K2GFoursquareManager.h"

#import <MapKit/MapKit.h>
#import "Foursquare2.h"


@implementation K2GFoursquareManager
{
    NSOperationQueue *_operationQueue;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _operationQueue = [NSOperationQueue new];
    
    return self;
}

+ (instancetype) sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (void) setupFoursquare
{
    [Foursquare2 setupFoursquareWithClientId:@"NQXVPHJJJDP0VZO0WQKDTJAKKZL4BO5A2IMT4AGMBNBL4RUG"
                                      secret:@"BY1Q5CJSQVCOOKN14LSGYSWLU0MZFKSQUEKKXFG2FOVS4SH3"
                                 callbackURL:@"k2g://foursquare"];
}

- (void) requestVenuesAround:(CLLocationCoordinate2D)coordinate handler:(K2GFoursquareVenuesResultHandler)handler;
{
    [Foursquare2 venueSearchNearByLatitude:@(coordinate.latitude) longitude:@(coordinate.longitude)
                                     query:nil limit:nil
                                    intent:intentBrowse
                                    radius:@(800)
                                categoryId:nil
                                  callback:^(BOOL success, id result) {
                                      if (handler) handler(success, result);
                                  }];
}

- (BOOL) handleURL:(NSURL*)url
{
    return [Foursquare2 handleURL:url];
}

@end
