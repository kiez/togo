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

#import "K2GFSVenue.h"


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
//    [Foursquare2 venueSearchNearByLatitude:@(coordinate.latitude) longitude:@(coordinate.longitude)
//                                     query:nil limit:nil
//                                    intent:intentBrowse
//                                    radius:@(800)
//                                categoryId:nil
//                                  callback:^(BOOL success, id result) {
//                                      if (success) {
//                                          NSArray *venues = [result valueForKeyPath:@"response.venues"];
//                                          NSMutableArray *venueObjects = [NSMutableArray array];
//                                          for (NSDictionary *dict in venues) {
//                                              K2GFSVenue *venue = [[K2GFSVenue alloc] initWithFoursquareDictionary:dict];
//                                              [venueObjects addObject:venue];
//                                          }
//                                          if (handler) handler(venueObjects, nil);
//                                      } else {
//                                          if (handler) handler(nil, [NSError errorWithDomain:@"K2GFoursquareManagerErrorDomain"
//                                                                                        code:-1
//                                                                                    userInfo:@{
//                                                                                               NSLocalizedDescriptionKey: @"Could not load venues"
//                                                                                               }]);
//                                      }
//                                  }];
    [Foursquare2 venueExploreRecommendedNearByLatitude:@(coordinate.latitude) longitude:@(coordinate.longitude)
                                                  near:nil accuracyLL:@(800)
                                              altitude:nil accuracyAlt:nil
                                                 query:nil limit:nil offset:nil
                                                radius:nil section:nil novelty:nil sortByDistance:YES
                                               openNow:YES venuePhotos:YES price:nil
                                              callback:^(BOOL success, id result) {
                                                  if (success) {
                                                      NSArray *groups = [result valueForKeyPath:@"response.groups"];
                                                      NSDictionary *group = [groups firstObject];
                                                      NSArray *venues = [group valueForKeyPath:@"items.venue"];
                                                      NSMutableArray *venueObjects = [NSMutableArray array];
                                                      for (NSDictionary *dict in venues) {
                                                          K2GFSVenue *venue = [[K2GFSVenue alloc] initWithFoursquareDictionary:dict];
                                                          [venueObjects addObject:venue];
                                                      }
                                                      if (handler) handler(venueObjects, nil);
                                                  } else {
                                                      if (handler) handler(nil, [NSError errorWithDomain:@"K2GFoursquareManagerErrorDomain"
                                                                                                    code:-1
                                                                                                userInfo:@{
                                                                                                           NSLocalizedDescriptionKey: @"Could not load venues"
                                                                                                           }]);
                                                  }
                                              }];

}

- (BOOL) handleURL:(NSURL*)url
{
    return [Foursquare2 handleURL:url];
}

@end
