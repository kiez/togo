//
//  MKPolylineView+KML.m
//  MKMap+KML
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "KMLCoordinate.h"
#import "KMLPlacemark.h"
#import "KMLStyle.h"
#import "KMLLineString.h"
#import "KMLLineStyle.h"
#import "MKPolylineView+KML.h"
#import "MKOverlayView+KML.h"

@implementation MKPolylineView (KML)

- (KMLAbstractFeature *)generateFeature
{
    KMLPlacemark *placemark = [KMLPlacemark new];
    placemark.name = self.polyline.title;
    placemark.snippet = self.polyline.subtitle;

    KMLLineString *lineString = [KMLLineString new];
    placemark.geometry = lineString;

    MKMapPoint *points = self.polyline.points;
    for (int i = 0; i < self.polyline.pointCount; i++) {
        MKMapPoint point = points[i];
        CLLocationCoordinate2D coord = MKCoordinateForMapPoint(point);
        
        KMLCoordinate *coordinate = [KMLCoordinate new];
        coordinate.latitude = coord.latitude;
        coordinate.longitude = coord.longitude;
        [lineString addCoordinate:coordinate];
    }
    
    KMLStyle *style = [KMLStyle new];
    KMLLineStyle *lineStyle = [KMLLineStyle new];
    lineStyle.UIColor = self.strokeColor;
    lineStyle.width = self.lineWidth;
    
    style.lineStyle = lineStyle;
    [placemark addStyleSelector:style];

    return placemark;
}

@end
