//
//  KMLAbstractGeometry+MapKit.h
//  KML+MapKit
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "KMLAbstractGeometry.h"
#import "KMLPlacemark.h"

@interface KMLAbstractGeometry (MapKit)

- (KMLPlacemark *)placemark;
- (MKShape *)mapkitShape;
- (MKAnnotationView *)annotationViewForMapView:(MKMapView *)mapView annotation:(id<MKAnnotation>)annotation;
- (MKOverlayView *)overlayViewForMapView:(MKMapView *)mapView overlay:(id<MKOverlay>)overlay;

@end
