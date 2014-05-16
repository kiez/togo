//
//  MKAnnotationView+KML.h
//  MKMap+KML
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "KMLAbstractFeature.h"

@interface MKAnnotationView (KML)

- (KMLAbstractFeature *)generateFeature;

@end
