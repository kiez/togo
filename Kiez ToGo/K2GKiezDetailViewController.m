//
//  K2GKiezDetailViewController.m
//  Kiez ToGo
//
//  Created by Ullrich Schäfer on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "K2GKiezDetailViewController.h"
#import <iOS-KML-Framework/KML.h>

#import "K2GKiezManager.h"
#import "K2GKiez.h"

#import "KML+MapKit.h"
#import "MKMap+KML.h"
#import "K2GKiezDetailView.h"
#import "K2GFoursquareVenueCell.h"
#import "KMLPolygon+K2G.h"
#import "K2GFoursquareVenueViewController.h"

#import "K2GFoursquareManager.h"
#import "K2GFSVenue.h"
#import "K2GFSLocation.h"
#import "UIColor+K2G.h"

typedef NS_ENUM(NSInteger, K2GKiezDetailViewControllerState) {
    K2GKiezDetailViewControllerStateOverview,
    K2GKiezDetailViewControllerStateDetail
};

static const CLLocationDegrees kBerlinLatitude  = 52.520078;
static const CLLocationDegrees kBerlinLongitude = 13.405993;
static const CLLocationDegrees kBerlinSpan = 0.35;
static const CLLocationDegrees kKiezSpan = 0.04;
static const CLLocationAccuracy kDesiredLocationAccuracy = 100; // meters
static const CGFloat kDisabledOverlayAlpha = 0.3;
static const CGFloat kActiveOverlayAlpha = 0.8;

static NSString * const kFoursquareVenueCellReuseIdentifier = @"kFoursquareVenueCellReuseIdentifier";

@interface K2GKiezDetailViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) KMLRoot *kml;
@property (nonatomic) K2GKiezDetailView *view;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong) NSMutableDictionary *mapFromOverlayIndexToKiez;
@property (nonatomic, copy) NSArray *overlays;

@property (nonatomic, strong) NSArray *venues;

@property (nonatomic) K2GKiezDetailViewControllerState state;

@property (nonatomic, strong) K2GKiez *activeKiez;
@property (nonatomic, strong) MKPolygon *activePolygon;

@property (nonatomic) BOOL foundAccurateUserLocation;

@end

@implementation K2GKiezDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"curloc"] style:UIBarButtonItemStylePlain target:self action:@selector(focusOnCurrentLocation:)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    self.state = K2GKiezDetailViewControllerStateDetail;
    
    self.view.tableView.dataSource = self;
    self.view.tableView.delegate = self;
    self.view.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 100, 0);
    self.view.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    [self.view.tableView registerNib:[UINib nibWithNibName:@"K2GFoursquareVenueCell" bundle:nil] forCellReuseIdentifier:kFoursquareVenueCellReuseIdentifier];
    
    CLLocationCoordinate2D berlinCenterCoordinate = CLLocationCoordinate2DMake(kBerlinLatitude, kBerlinLongitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(kBerlinSpan, kBerlinSpan);
    MKCoordinateRegion region = MKCoordinateRegionMake(berlinCenterCoordinate, span);
    [self.mapView setRegion:region];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"LOR-Planungsraeume" withExtension:@"kml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    self.kml        = [KMLParser parseKMLWithData:data];
    
    [self reloadMapView];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self.view.tableView deselectRowAtIndexPath:[self.view.tableView indexPathForSelectedRow] animated:YES];
}

- (void)reloadMapView
{
  if (!self.mapFromOverlayIndexToKiez)
  {
    self.mapFromOverlayIndexToKiez = [NSMutableDictionary new];
  }
  
  NSMutableArray *annotations = [NSMutableArray new];
  NSMutableArray *overlays    = [NSMutableArray new];
  
  
  [[[K2GKiezManager defaultManager] kiezes] enumerateObjectsUsingBlock:^(K2GKiez *kiez, NSUInteger idx, BOOL *stop)
   {
     KMLAbstractGeometry *geometry = kiez.geometry;
     MKShape *mkShape = [geometry mapkitShape];
     if (mkShape) {
       if ([mkShape conformsToProtocol:@protocol(MKOverlay)]) {
         NSNumber *index = @([overlays count]);
         [overlays addObject:mkShape];
         self.mapFromOverlayIndexToKiez[index] = kiez;
       }
       else if ([mkShape isKindOfClass:[MKPointAnnotation class]]) {
         [annotations addObject:mkShape];
       }
     }
   }];

  
//  [self.kml.placemarks enumerateObjectsUsingBlock:^(KMLPlacemark *placemark, NSUInteger idx, BOOL *stop)
//   {
//     KMLAbstractGeometry *geometry = [self geometryForPlacemark:placemark];
//
//     MKShape *mkShape = [geometry mapkitShape];
//     if (mkShape) {
//       if ([mkShape conformsToProtocol:@protocol(MKOverlay)]) {
//         NSNumber *index = @([overlays count]);
//         [overlays addObject:mkShape];
//         
//         self.mapFromOverlayIndexToPlacemarkName[index] = placemark.name;
//       }
//       else if ([mkShape isKindOfClass:[MKPointAnnotation class]]) {
//         [annotations addObject:mkShape];
//       }
//     }
//   }];
  
  [self.mapView addAnnotations:annotations];
  [self.mapView addOverlays:overlays];
  
  self.overlays = overlays;
}

- (void)zoomToKiezFromCoordinate:(CLLocationCoordinate2D)coordinate
{
  K2GKiez *kiez = nil;
  MKPolygon *polygonOverlay = nil;
  for (NSUInteger i = 0; i < [self.overlays count]; ++i)
  {
    polygonOverlay = self.overlays[i];
    if ([self polygon:polygonOverlay contains:coordinate])
    {
      NSNumber *index = @(i);
      kiez = self.mapFromOverlayIndexToKiez[index];
      break;
    }
  }
  
  if (!kiez)
  {
    DLog(@"coordinate not in any kiez");
    return;
  }
    
  [self setActiveKiez:kiez withPolygon:polygonOverlay];
  [self zoomToKiez:kiez];
}

- (void)zoomToKiez:(K2GKiez*)kiez
{
  KMLPolygon *polygon = (KMLPolygon *) kiez.geometry;
  
  CLLocationCoordinate2D kiezCenterCoordinate = [polygon centerCoordinate];
  MKCoordinateSpan span = MKCoordinateSpanMake(kKiezSpan, kKiezSpan);
  MKCoordinateRegion region = MKCoordinateRegionMake(kiezCenterCoordinate, span);
  [self.mapView setRegion:region animated:YES];
    
    self.title = kiez.name;
    
    [self loadVenuesAtLocation:kiezCenterCoordinate];
}

- (void)setActiveKiez:(K2GKiez *)kiez withPolygon:(MKPolygon *)polygonOverlay
{
  // deselect the old polygon
  if (self.activePolygon)
  {
    MKPolygonRenderer *renderer = (MKPolygonRenderer *) [self.mapView rendererForOverlay:self.activePolygon];
    
    [self configureDisabledRenderer:renderer];
  }
  
  self.activeKiez    = kiez;
  self.activePolygon = polygonOverlay;
  
  // select the new polygon
  
  MKPolygonRenderer *renderer = (MKPolygonRenderer *) [self.mapView rendererForOverlay:polygonOverlay];
  
  [self configureActiveRenderer:renderer];
}

- (void)configureDisabledRenderer:(MKPolygonRenderer *)renderer
{
  UIColor *color = [UIColor randomColor];
  renderer.fillColor   = [color colorWithAlphaComponent:kDisabledOverlayAlpha];
  renderer.strokeColor = color;
  renderer.lineWidth   = 1.0 / [[UIScreen mainScreen] scale];
}

- (void)configureActiveRenderer:(MKPolygonRenderer *)renderer
{
  UIColor *color = [UIColor randomColor];
  renderer.fillColor   = [color colorWithAlphaComponent:kActiveOverlayAlpha];
  renderer.strokeColor = color;
  renderer.lineWidth   = 1.0 / [[UIScreen mainScreen] scale];
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
  
  MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
  
  MKPolygonRenderer *renderer = (MKPolygonRenderer *) [self.mapView rendererForOverlay:polygon];
  CGPoint polygonViewPoint = [renderer pointForMapPoint:mapPoint];

  BOOL result = NO;
  if (CGPathContainsPoint(renderer.path, NULL, polygonViewPoint, FALSE)) {
    result = YES;
  }
  
  return result;
  
}

- (void) search: (id) sender
{
    
}

- (void)setState:(K2GKiezDetailViewControllerState)state
{
    [self setState:state animated:NO];
}

- (void)setState:(K2GKiezDetailViewControllerState)state animated: (BOOL) anim
{
    _state = state;
    
    if (_state == K2GKiezDetailViewControllerStateDetail) {
        self.navigationItem.title = @"Mitte";
        [self.view showKiezDetailsAnimated:anim];
    } else {
        self.navigationItem.title = @"Kiez To Go";
        
        [self.view showOverviewAnimated:anim];
    }
}

#pragma mark UI Callbacks
- (IBAction)mapViewTapped:(UITapGestureRecognizer *)sender
{
  
    if (sender.state != UIGestureRecognizerStateEnded)
    {
        return;
    }
  
    if (self.state == K2GKiezDetailViewControllerStateOverview) {
    
        CGPoint point = [sender locationInView:sender.view];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
  
        [self zoomToKiezFromCoordinate:coordinate];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setState:K2GKiezDetailViewControllerStateDetail animated:YES];
        });
        
    } else {
        [self setState:K2GKiezDetailViewControllerStateOverview animated: YES];
    }
}

- (void)focusOnCurrentLocation:(id)sender
{
    self.mapView.showsUserLocation = YES;
    
    if (self.mapView.userLocation.updating) {
        [self zoomToKiezFromCoordinate: self.mapView.userLocation.coordinate];
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

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
  if ([overlay isKindOfClass:[MKPolygon class]])
  {
    MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
    [self configureDisabledRenderer:renderer];
    
    return renderer;
  }
  
  return nil;
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView NS_AVAILABLE(10_9, 4_0);
{
    [self.spinner startAnimating];
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView NS_AVAILABLE(10_9, 4_0);
{
    [self.spinner stopAnimating];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocation *location = [userLocation location];
    
    if (location.horizontalAccuracy < kDesiredLocationAccuracy && self.foundAccurateUserLocation == NO)
    {
        self.foundAccurateUserLocation = YES;
        [self zoomToKiezFromCoordinate:location.coordinate];
    }
}


#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    K2GFoursquareVenueCell *cell = [tableView dequeueReusableCellWithIdentifier:kFoursquareVenueCellReuseIdentifier];
    
    K2GFSVenue *venue = _venues[indexPath.row];
    if (venue.rating == MAXFLOAT) {
        cell.gradeLabel.text = @"--";
    } else {
        cell.gradeLabel.text = [NSString stringWithFormat:@"%1.1f", venue.rating];
    }
    cell.titleLabel.text = venue.name;
    cell.titleType.text = venue.primaryCategoryName;
    cell.addressLabel.text = venue.location.address;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    K2GFSVenue *venue = _venues[indexPath.row];
    [self openDetailsOfVenueWithIdentifier:venue.identifier];
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


#pragma mark - Venue Loadng

- (void) loadVenuesAtLocation:(CLLocationCoordinate2D)location
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.tableView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         _venues = @[];
                         [self.view.tableView reloadData];
                         
                         [[K2GFoursquareManager sharedInstance] requestVenuesAround:location
                                                                            handler:^(NSArray *venues, NSError *error) {
                                                                                _venues = venues;
                                                                                [self.view.tableView reloadData];
                                                                                
                                                                                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                                                                                                 animations:^{
                                                                                                     self.view.tableView.alpha = 1.0;
                                                                                                 }
                                                                                                 completion:NULL];

                                                                            }];
                     }];
    
}

@end
