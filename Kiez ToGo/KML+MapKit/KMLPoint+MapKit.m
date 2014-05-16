//
//  KMLPoint+MapKit.m
//  KML+MapKit
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "KMLCoordinate.h"
#import "KMLPlacemark.h"
#import "KMLStyle.h"
#import "KMLIconStyle.h"
#import "KMLIcon.h"
#import "KMLPlacemark+MapKit.h"
#import "KMLAbstractGeometry+MapKit.h"
#import "MKShape+KML.h"
#import "KMLPoint+MapKit.h"

@implementation KMLPoint (MapKit)

- (MKShape *)mapkitShape
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.coordinate.latitude, self.coordinate.longitude);
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.geometry = self;
    annotation.coordinate = coordinate;
    
    return annotation;
}

- (MKAnnotationView *)annotationViewForMapView:(MKMapView *)mapView annotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView;
    
    KMLPlacemark *placemark = self.placemark;
    
    if (placemark.hasIcon) {
        NSString *AnnotationViewIdentifer = @"AnnotationView";
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewIdentifer];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewIdentifer];
        } else {
            annotationView.annotation = annotation;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *icon = placemark.icon;

            dispatch_async(dispatch_get_main_queue(), ^{
                annotationView.image = icon;
            });
        });

    } else {
        NSString *PinAnnotationViewIdentifer = @"PinAnnotationView";
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:PinAnnotationViewIdentifer];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PinAnnotationViewIdentifer];
        } else {
            annotationView.annotation = annotation;
        }
    }
    
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return annotationView;
}

@end
