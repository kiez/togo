//
//  K2GKiez.h
//  Kiez ToGo
//
//  Created by Ullrich Schäfer on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import <Foundation/Foundation.h>

@class KMLPlacemark;
@class KMLAbstractGeometry;

@interface K2GKiez : NSObject

+ (instancetype)kiezFromPlacemark:(KMLPlacemark *)placemark;

@property (readonly) NSString *identifier;
@property (readonly) NSString *name;   //
@property (readonly) NSString *district; //i.e. Neukölln
@property (readonly) NSString *area; //i.e. Britz
@property (readonly) float sizeInHa;

@property (readonly) KMLPlacemark *placemark;
@property (readonly) KMLAbstractGeometry *geometry; // the main geometry

@end
