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
#import "K2GFoursquareVenueViewController.h"

static const CLLocationDegrees kBerlinLatitude  = 52.520078;
static const CLLocationDegrees kBerlinLongitude = 13.405993;
static const CLLocationDegrees kBerlinSpan = 0.35;

static NSString * const kFoursquareVenueCellReuseIdentifier = @"kFoursquareVenueCellReuseIdentifier";

@interface K2GKiezDetailViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) KMLRoot *kml;
@property (nonatomic) NSArray *geometries;
@property (nonatomic) NSArray *filteredGeometries;
@property (nonatomic) K2GKiezDetailView *view;

@end

@implementation K2GKiezDetailViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
    
  self.navigationItem.title = @"Mitte";

  self.view.tableView.dataSource = self;
  self.view.tableView.delegate = self;
  [self.view.tableView registerNib:[UINib nibWithNibName:@"K2GFoursquareVenueCell" bundle:nil] forCellReuseIdentifier:kFoursquareVenueCellReuseIdentifier];
  
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view.tableView deselectRowAtIndexPath:[self.view.tableView indexPathForSelectedRow] animated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

#pragma mark UI Callbacks
- (IBAction)mapViewTapped:(id)sender
{
    if (self.mapView.frame.size.height > 235) {
        [self.view showKiezDetailsAnimated:YES];
    } else {
        [self.view showOverviewAnimated:YES];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self openDetailsOfVenueWithIdentifier:@"4ade123bf964a520d87221e3"];
}

- (void) openDetailsOfVenueWithIdentifier: (NSString *) venueIdentifier
{
    NSURL *nativeAppURL = [NSURL URLWithString:[NSString stringWithFormat:@"foursquare://venues/%@", venueIdentifier]];
    
    if ([[UIApplication sharedApplication] canOpenURL:nativeAppURL]) {
        [[UIApplication sharedApplication] openURL: nativeAppURL];
        [self.view.tableView deselectRowAtIndexPath:[self.view.tableView indexPathForSelectedRow] animated:YES];
    } else {
        K2GFoursquareVenueViewController *venueDetailVC = [[K2GFoursquareVenueViewController alloc] initWithVenueIdentifier:venueIdentifier];
        [self.navigationController pushViewController:venueDetailVC animated:YES];
    }
}

@end
