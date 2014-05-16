//
//  KMLRoot+MapKit.m
//  KML+MapKit
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "KMLDocument.h"
#import "KMLMultiGeometry.h"
#import "KMLRoot+MapKit.h"
#import "KMLAbstractGeometry+MapKit.h"
#import "MKAnnotationView+KML.h"
#import "MKOverlayView+KML.h"

@implementation KMLRoot (MapKit)

+ (KMLRoot *)generateKMLWithMapView:(MKMapView *)mapView
{
    KMLRoot *rootElement = [KMLRoot new];

    KMLDocument *document = [KMLDocument new];
    rootElement.feature = document;
    
    for (id<MKAnnotation> annotation in mapView.annotations) {
        MKAnnotationView *annotationView = [mapView viewForAnnotation:annotation];
        if (annotationView) {
            KMLAbstractFeature *feature = [annotationView generateFeature];
            if (feature) {
                [document addFeature:feature];
            }
        }
    }
    
    for (id<MKOverlay> overlay in mapView.overlays) {
        MKOverlayView *overlayView = [mapView viewForOverlay:overlay];
        if (overlayView) {
            KMLAbstractFeature *feature = [overlayView generateFeature];
            if (feature) {
                [document addFeature:feature];
            }
        }
    }
    
    return rootElement;
}

- (NSString *)name
{
    if (self.feature
        && [self.feature isKindOfClass:[KMLDocument class]]) {
        KMLDocument *document = (KMLDocument *)self.feature;
        
        return document.name;
    }
    
    return nil;
}

- (NSArray *)geometries
{
    NSMutableArray *geometries = [NSMutableArray array];
    for (KMLPlacemark *placemark in self.placemarks) {
        if (placemark.geometry) {
            if ([placemark.geometry isKindOfClass:[KMLMultiGeometry class]]) {
                KMLMultiGeometry *multiGeometry = (KMLMultiGeometry *)placemark.geometry;
                for (KMLAbstractGeometry *geometry in multiGeometry.geometries) {
                    if (geometry) {
                        [geometries addObject:geometry];
                    }
                }
                
            } else {
                [geometries addObject:placemark.geometry];
            }
        }
    }
    
    return geometries;
}

@end
