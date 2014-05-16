//
//  KMLPolygon+K2G.m
//  Kiez ToGo
//
//  Created by Stanley Rost on 16.05.14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "KMLPolygon+K2G.h"
#import "KML.h"

@implementation KMLPolygon (K2G)

// probably not precise but good enough
- (CLLocationCoordinate2D)centerCoordinate
{
  // FIXME does not work across the 180th meridian
  double sumLat = 0;
  double sumLng = 0;
  
  NSUInteger numberOfCoordinates = [self.outerBoundaryIs.coordinates count];
  for (NSUInteger i = 0; i < numberOfCoordinates; ++i)
  {
    KMLCoordinate *coord = self.outerBoundaryIs.coordinates[i];
    CGFloat lat0 = coord.latitude;
    CGFloat lng0 = coord.longitude;
    
    sumLat += lat0;
    sumLng += lng0;
  }
  
  return CLLocationCoordinate2DMake(sumLat / numberOfCoordinates, sumLng / numberOfCoordinates);
}

@end
