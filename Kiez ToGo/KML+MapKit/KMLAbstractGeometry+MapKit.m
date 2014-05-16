//
//  KMLAbstractGeometry+MapKit.m
//  KML+MapKit
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "KMLElement.h"
#import "KMLAbstractGeometry+MapKit.h"

@implementation KMLAbstractGeometry (MapKit)

- (KMLPlacemark *)placemark
{
    KMLElement *parent = self.parent;
    while (parent) {
        if ([parent isKindOfClass:[KMLPlacemark class]]) {
            return (KMLPlacemark *)parent;
        }
        
        parent = parent.parent;
    }
    
    return nil;
}

- (MKShape *)mapkitShape
{
    return nil;
}

- (MKAnnotationView *)annotationViewForMapView:(MKMapView *)mapView annotation:(id<MKAnnotation>)annotation
{
    return nil;
}

- (MKOverlayView *)overlayViewForMapView:(MKMapView *)mapView overlay:(id<MKOverlay>)overlay
{
    return nil;
}

@end
