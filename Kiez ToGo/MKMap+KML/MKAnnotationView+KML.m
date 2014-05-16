//
//  MKAnnotationView+KML.m
//  MKMap+KML
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "KMLCoordinate.h"
#import "KMLPoint.h"
#import "KMLPlacemark.h"
#import "MKAnnotationView+KML.h"

@implementation MKAnnotationView (KML)

- (KMLAbstractFeature *)generateFeature
{
    KMLPlacemark *placemark = [KMLPlacemark new];
    placemark.name = self.annotation.title;
    placemark.snippet = self.annotation.subtitle;

    KMLPoint *point = [KMLPoint new];
    placemark.geometry = point;

    KMLCoordinate *coordinate = [KMLCoordinate new];
    coordinate.latitude = self.annotation.coordinate.latitude;
    coordinate.longitude = self.annotation.coordinate.longitude;
    point.coordinate = coordinate;
    
    return placemark;
}

@end
