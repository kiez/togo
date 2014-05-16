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
#import "K2GKiezDetailView.h"
#import "K2GFoursquareVenueCell.h"
#import "KMLPolygon+K2G.h"

static const CLLocationDegrees kBerlinLatitude  = 52.520078;
static const CLLocationDegrees kBerlinLongitude = 13.405993;
static const CLLocationDegrees kBerlinSpan = 0.35;
static const CLLocationDegrees kKiezSpan = 0.04;
static const CLLocationAccuracy kDesiredLocationAccuracy = 100; // meters

static NSString * const kFoursquareVenueCellReuseIdentifier = @"kFoursquareVenueCellReuseIdentifier";

@interface K2GKiezDetailViewController () <MKMapViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) KMLRoot *kml;
@property (nonatomic) K2GKiezDetailView *view;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong) NSMutableDictionary *mapFromOverlayIndexToPlacemarkName;
@property (nonatomic, copy) NSArray *overlays;

@end

@implementation K2GKiezDetailViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.view.tableView.dataSource = self;
  [self.view.tableView registerNib:[UINib nibWithNibName:@"K2GFoursquareVenueCell" bundle:nil] forCellReuseIdentifier:kFoursquareVenueCellReuseIdentifier];
  
  CLLocationCoordinate2D berlinCenterCoordinate = CLLocationCoordinate2DMake(kBerlinLatitude, kBerlinLongitude);
  MKCoordinateSpan span = MKCoordinateSpanMake(kBerlinSpan, kBerlinSpan);
  MKCoordinateRegion region = MKCoordinateRegionMake(berlinCenterCoordinate, span);
  [self.mapView setRegion:region];
  
  NSURL *url = [[NSBundle mainBundle] URLForResource:@"LOR-Bezirksregionen" withExtension:@"kml"];
  NSData *data = [NSData dataWithContentsOfURL:url];
  
  self.kml = [KMLParser parseKMLWithData:data];
  
  [self reloadMapView];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self.locationManager startUpdatingLocation];
  [self.spinner startAnimating];
}

- (void)reloadMapView
{
  if (!self.mapFromOverlayIndexToPlacemarkName)
  {
    self.mapFromOverlayIndexToPlacemarkName = [NSMutableDictionary new];
  }
  
  NSMutableArray *annotations = [NSMutableArray new];
  NSMutableArray *overlays    = [NSMutableArray new];
  
  [self.kml.placemarks enumerateObjectsUsingBlock:^(KMLPlacemark *placemark, NSUInteger idx, BOOL *stop)
   {
     KMLAbstractGeometry *geometry = [self geometryForPlacemark:placemark];

     MKShape *mkShape = [geometry mapkitShape];
     if (mkShape) {
       if ([mkShape conformsToProtocol:@protocol(MKOverlay)]) {
         NSNumber *index = @([overlays count]);
         [overlays addObject:mkShape];
         
         self.mapFromOverlayIndexToPlacemarkName[index] = placemark.name;
       }
       else if ([mkShape isKindOfClass:[MKPointAnnotation class]]) {
         [annotations addObject:mkShape];
       }
     }
   }];
  
  [self.mapView addAnnotations:annotations];
  [self.mapView addOverlays:overlays];
  
  self.overlays = overlays;
}

- (void)stopLocationUpdates
{
  [self.locationManager stopUpdatingLocation];
  [self.spinner stopAnimating];
}

- (void)zoomToKiezFromLocation:(CLLocation *)location
{
  DLog(@"user location: %@", location);
  
  KMLPlacemark *foundPlacemark = nil;
  for (NSUInteger i = 0; i < [self.overlays count]; ++i)
  {
    MKPolygon *polygon = self.overlays[i];
    if ([self polygon:polygon contains:location.coordinate])
    {
      NSNumber *index = @(i);
      NSString *name = self.mapFromOverlayIndexToPlacemarkName[index];
      foundPlacemark = [self placemarkForName:name];
      break;
    }
  }
  
  if (!foundPlacemark)
  {
    DLog(@"user not in kiez");
    return;
  }

  DLog(@"kiez found: %@", foundPlacemark.name);
  KMLPolygon *polygon = (KMLPolygon *) [self geometryForPlacemark:foundPlacemark];
  
  CLLocationCoordinate2D kiezCenterCoordinate = [polygon centerCoordinate];
  MKCoordinateSpan span = MKCoordinateSpanMake(kKiezSpan, kKiezSpan);
  MKCoordinateRegion region = MKCoordinateRegionMake(kiezCenterCoordinate, span);
  [self.mapView setRegion:region animated:YES];
}

- (KMLPlacemark *)placemarkForName:(NSString *)name
{
  for (KMLPlacemark *placemark in self.kml.placemarks)
  {
    if ([placemark.name isEqualToString:name])
    {
      return placemark;
    }
  }
  
  return nil;
}

- (KMLAbstractGeometry *)geometryForPlacemark:(KMLPlacemark *)placemark
{
  KMLAbstractGeometry *geometry = placemark.geometry;
  
  if ([geometry respondsToSelector:@selector(geometries)])
  {
    NSArray *geometries = [(KMLMultiGeometry *)geometry geometries];
    NSAssert([geometries count] == 1, @"expected one geometry object");
    
    geometry = [geometries firstObject];
  }

  return geometry;
}

- (BOOL)polygon:(MKPolygon *)polygon contains:(CLLocationCoordinate2D)coordinate
{
//  http://stackoverflow.com/questions/19014926/detecting-a-point-in-a-mkpolygon-broke-with-ios7-cgpathcontainspoint
  
  MKPolygonView *polygonView = (MKPolygonView *)[self.mapView viewForOverlay:polygon];
  MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
  CGPoint polygonViewPoint = [polygonView pointForMapPoint:mapPoint];

  BOOL result = NO;
  if (CGPathContainsPoint(polygonView.path, NULL, polygonViewPoint, FALSE)) {
    result = YES;
  }
  
  return result;
  
}

- (BOOL)notworking_polygon:(MKPolygon *)polygon contains:(CLLocationCoordinate2D)coordinate
{

  // see http://stackoverflow.com/questions/19014926/detecting-a-point-in-a-mkpolygon-broke-with-ios7-cgpathcontainspoint
  
  MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
  
  CGMutablePathRef mpr = CGPathCreateMutable();
  
  MKMapPoint *polygonPoints = polygon.points;
  
  for (int p=0; p < polygon.pointCount; p++)
  {
    MKMapPoint mp = polygonPoints[p];
    if (p == 0)
      CGPathMoveToPoint(mpr, NULL, mp.x, mp.y);
    else
      CGPathAddLineToPoint(mpr, NULL, mp.x, mp.y);
  }
  
  CGPoint mapPointAsCGP = CGPointMake(mapPoint.x, mapPoint.y);
  
  BOOL pointIsInPolygon = CGPathContainsPoint(mpr, NULL, mapPointAsCGP, FALSE);
  
  CGPathRelease(mpr);
  
  return pointIsInPolygon;
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

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    K2GFoursquareVenueCell *cell = [tableView dequeueReusableCellWithIdentifier:kFoursquareVenueCellReuseIdentifier];
    
    return cell;
}

#pragma mark Location & CLLocationManagerDelegate

- (CLLocationManager *)locationManager
{
  if (!_locationManager)
  {
    if (
        [CLLocationManager locationServicesEnabled] &&
        (
         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ||
         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         )
        )
    {
      _locationManager = [CLLocationManager new];
      _locationManager.delegate = self;
    }
  }
  
  return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  CLLocation *location = [locations lastObject];

  if (location.horizontalAccuracy < kDesiredLocationAccuracy)
  {
    [self stopLocationUpdates];
    [self zoomToKiezFromLocation:location];
  }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  // [self stopLocationUpdates];
  
  DLog(@"Could not update user location");
}

@end
