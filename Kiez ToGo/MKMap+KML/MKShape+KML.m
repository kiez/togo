//
//  MKShape+KML.m
//  MKMap+KML
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import <objc/runtime.h>
#import "KMLAbstractFeature.h"
#import "KMLPlacemark.h"
#import "KMLAbstractGeometry+MapKit.h"
#import "MKShape+KML.h"

@implementation MKShape (KML)

- (NSString *)title
{
    KMLAbstractGeometry *geometry = self.geometry;
    KMLPlacemark *placemark = geometry.placemark;
    if (placemark) {
        return placemark.name;
    }

    return nil;
}

- (NSString *)subtitle
{
    KMLAbstractGeometry *geometry = self.geometry;
    KMLPlacemark *placemark = geometry.placemark;
    if (placemark) {
        return placemark.snippet;
    }
    
    return nil;
}


#pragma mark - Getter/Setter

- (KMLAbstractGeometry *)geometry
{
    return objc_getAssociatedObject(self, "kMKShapeGeometryKey");
}

- (void)setGeometry:(KMLAbstractGeometry *)geometry
{
    objc_setAssociatedObject(self, "kMKShapeGeometryKey", geometry, OBJC_ASSOCIATION_RETAIN);
}


#pragma mark - 

- (MKAnnotationView *)annotationViewForMapView:(MKMapView *)mapView
{
    KMLAbstractGeometry *geometry = self.geometry;
    if (geometry) {
        return [geometry annotationViewForMapView:mapView annotation:self];
    }
    
    return nil;
}

- (MKOverlayView *)overlayViewForMapView:(MKMapView *)mapView
{
    KMLAbstractGeometry *geometry = self.geometry;
    if (geometry) {
        return [geometry overlayViewForMapView:mapView overlay:(id<MKOverlay>)self];
    }

    return nil;
}

@end
