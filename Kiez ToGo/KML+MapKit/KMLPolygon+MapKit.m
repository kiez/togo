//
//  KMLPolygon+MapKit.m
//  KML+MapKit
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "KMLCoordinate.h"
#import "KMLLinearRing.h"
#import "KMLPlacemark.h"
#import "KMLStyle.h"
#import "KMLLineStyle.h"
#import "KMLPolyStyle.h"
#import "MKShape+KML.h"
#import "KMLPolygon+MapKit.h"
#import "KMLAbstractGeometry+MapKit.h"

@implementation KMLPolygon (MapKit)

- (MKShape *)mapkitShape
{
    NSArray *outerCoordinates = self.outerBoundaryIs.coordinates;
    
    if (outerCoordinates.count > 0) {
        CLLocationCoordinate2D coors[outerCoordinates.count];
        
        int i = 0;
        for (KMLCoordinate *coordinate in outerCoordinates) {
            coors[i] = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
            i++;
        }
        
        MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coors count:outerCoordinates.count];
        polygon.geometry = self;
        return polygon;
    }
    
    return nil;
}

- (MKOverlayView *)overlayViewForMapView:(MKMapView *)mapView overlay:(id<MKOverlay>)overlay
{
    MKPolygonView *overlayView = [[MKPolygonView alloc] initWithOverlay:overlay];
    
    KMLPlacemark *placemark = self.placemark;

    KMLPolyStyle *polyStyle = [KMLPolyStyle new];
    KMLLineStyle *lineStyle = [KMLLineStyle new];
    
    KMLStyle *style = placemark.style;
    if (style) {
        if (style.polyStyle) {
            polyStyle = style.polyStyle;
        }
        if (style.lineStyle) {
            lineStyle = style.lineStyle;
        }
    }
  
  polyStyle.fill = YES;
  
  // TODO Stan random light color for each shape
  CGFloat hue = (float)arc4random_uniform(1000)/1000.0;
  CGFloat saturation = 0.7;
  CGFloat brightness = 0.8;
  CGFloat alpha = 0.5;
  
  polyStyle.UIColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
  
    if (polyStyle.fill) {
        overlayView.fillColor = polyStyle.UIColor;
    }

    if (polyStyle.outline) {
        overlayView.strokeColor = lineStyle.UIColor;
        overlayView.lineWidth = lineStyle.width;
    }
    
    return overlayView;
}

@end
