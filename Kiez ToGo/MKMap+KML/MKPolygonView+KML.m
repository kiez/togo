//
//  MKPolygonView+KML.m
//  MKMap+KML
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "KMLPolygon.h"
#import "KMLCoordinate.h"
#import "KMLLinearRing.h"
#import "KMLPlacemark.h"
#import "KMLStyle.h"
#import "KMLLineStyle.h"
#import "KMLPolyStyle.h"
#import "MKPolygonView+KML.h"

@implementation MKPolygonView (KML)

- (KMLAbstractFeature *)generateFeature
{
    KMLPlacemark *placemark = [KMLPlacemark new];
    placemark.name = self.polygon.title;
    placemark.snippet = self.polygon.subtitle;

    KMLPolygon *polygon = [KMLPolygon new];
    placemark.geometry = polygon;
    
    KMLLinearRing *outerBoundaryIs = [KMLLinearRing new];
    polygon.outerBoundaryIs = outerBoundaryIs;

    MKMapPoint *points = self.polygon.points;
    for (int i = 0; i < self.polygon.pointCount; i++) {
        MKMapPoint point = points[i];
        CLLocationCoordinate2D coord = MKCoordinateForMapPoint(point);
        
        KMLCoordinate *coordinate = [KMLCoordinate new];
        coordinate.latitude = coord.latitude;
        coordinate.longitude = coord.longitude;
        [outerBoundaryIs addCoordinate:coordinate];
    }

    KMLStyle *style = [KMLStyle new];
    
    KMLLineStyle *lineStyle = [KMLLineStyle new];
    lineStyle.UIColor = self.strokeColor;
    lineStyle.width = self.lineWidth;
    style.lineStyle = lineStyle;
    
    KMLPolyStyle *polyStyle = [KMLPolyStyle new];
    polyStyle.UIColor = self.fillColor;
    style.polyStyle = polyStyle;

    [placemark addStyleSelector:style];
    
    return placemark;
}

@end
