//
//  KMLLineString+MapKit.m
//  KML+MapKit
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "KMLCoordinate.h"
#import "KMLPlacemark.h"
#import "KMLStyle.h"
#import "KMLLineStyle.h"
#import "MKShape+KML.h"
#import "KMLLineString+MapKit.h"
#import "KMLAbstractGeometry+MapKit.h"

@implementation KMLLineString (MapKit)

- (MKShape *)mapkitShape
{
    if (self.coordinates.count > 0) {
        CLLocationCoordinate2D coors[self.coordinates.count];
        
        int i = 0;
        for (KMLCoordinate *coordinate in self.coordinates) {
            coors[i] = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
            i++;
        }
        
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coors count:self.coordinates.count];
        polyline.geometry = self;
        return polyline;
    }
    
    return nil;
}

- (MKOverlayView *)overlayViewForMapView:(MKMapView *)mapView overlay:(id<MKOverlay>)overlay
{
    MKPolylineView *overlayView = [[MKPolylineView alloc] initWithOverlay:overlay];

    KMLPlacemark *placemark = self.placemark;
    
    KMLLineStyle *lineStyle = [KMLLineStyle new];
    
    KMLStyle *style = placemark.style;
    if (style) {
        if (style.lineStyle) {
            lineStyle = style.lineStyle;
        }
    }

    overlayView.strokeColor = lineStyle.UIColor;
    overlayView.lineWidth = lineStyle.width;

    return overlayView;
}

@end
