//
//  K2GKiezDetailViewController.m
//  Kiez ToGo
//
//  Created by Ullrich Schäfer on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "K2GKiezDetailViewController.h"
#import <iOS-KML-Framework/KML.h>

#import "KML+MapKit.h"
#import "MKMap+KML.h"

static const CLLocationDegrees kBerlinLatitude  = 52.520078;
static const CLLocationDegrees kBerlinLongitude = 13.405993;
static const CLLocationDegrees kBerlinSpan = 0.35;

@interface K2GKiezDetailViewController () <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) KMLRoot *kml;
@property (nonatomic) NSArray *geometries;
@property (nonatomic) NSArray *filteredGeometries;

@end

@implementation K2GKiezDetailViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  CLLocationCoordinate2D berlinCenterCoordinate = CLLocationCoordinate2DMake(kBerlinLatitude, kBerlinLongitude);
  MKCoordinateSpan span = MKCoordinateSpanMake(kBerlinSpan, kBerlinSpan);
  MKCoordinateRegion region = MKCoordinateRegionMake(berlinCenterCoordinate, span);
  [self.mapView setRegion:region];
  
  NSURL *url = [[NSBundle mainBundle] URLForResource:@"LOR-Bezirksregionen" withExtension:@"kml"];
  NSData *data = [NSData dataWithContentsOfURL:url];
  
  self.kml        = [KMLParser parseKMLWithData:data];
  self.geometries = self.kml.geometries;
  
  [self reloadMapView];
}

- (void)reloadMapView
{
  NSMutableArray *annotations = [NSMutableArray new];
  NSMutableArray *overlays    = [NSMutableArray new];
  
  [self.geometries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
   {
     KMLAbstractGeometry *geometry = (KMLAbstractGeometry *)obj;
     MKShape *mkShape = [geometry mapkitShape];
     if (mkShape) {
       if ([mkShape conformsToProtocol:@protocol(MKOverlay)]) {
         [overlays addObject:mkShape];
       }
       else if ([mkShape isKindOfClass:[MKPointAnnotation class]]) {
         [annotations addObject:mkShape];
       }
     }
   }];
  
  [self.mapView addAnnotations:annotations];
  [self.mapView addOverlays:overlays];
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  else if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
    MKPointAnnotation *pointAnnotation = (MKPointAnnotation *)annotation;
    return [pointAnnotation annotationViewForMapView:mapView];
  }
  
  return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
  if ([overlay isKindOfClass:[MKPolyline class]]) {
    return [(MKPolyline *)overlay overlayViewForMapView:mapView];
  }
  else if ([overlay isKindOfClass:[MKPolygon class]]) {
    return [(MKPolygon *)overlay overlayViewForMapView:mapView];
  }
  
  return nil;
}

@end
