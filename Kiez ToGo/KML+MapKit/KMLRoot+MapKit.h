//
//  KMLRoot+MapKit.h
//  KML+MapKit
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "KMLRoot.h"

@interface KMLRoot (MapKit)

+ (KMLRoot *)generateKMLWithMapView:(MKMapView *)mapView;

- (NSString *)name;
- (NSArray *)geometries;

@end
