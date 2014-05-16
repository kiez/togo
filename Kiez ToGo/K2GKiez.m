//
//  K2GKiez.m
//  Kiez ToGo
//
//  Created by Ullrich Schäfer on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import <iOS-KML-Framework/KML.h>
#import <IGHTMLQuery/IGHTMLQuery.h>

#import "K2GKiez.h"

@interface K2GKiez ()
@property (readwrite) NSString *identifier;
@property (readwrite) NSString *name;   //
@property (readwrite) NSString *district; //i.e. Neukölln
@property (readwrite) NSString *area; //i.e. Britz
@property (readwrite) float sizeInHa;
@end

@implementation K2GKiez

+ (NSString *)getValueForKey:(NSString *)key fromHTML:(IGHTMLDocument *)htmlDoc
{
    NSString *xPath = [NSString stringWithFormat:@"//table//table//td[../td/text() = \"%@\"][2]/text()", key];
    IGXMLNodeSet *nodes = [htmlDoc queryWithXPath:xPath];
    IGXMLNode *node = [nodes firstObject];
    return node.xml;
}

+ (instancetype)kiezFromPlacemark:(KMLPlacemark *)placemark;
{
    K2GKiez *kiez = [K2GKiez new];
    
    kiez.name = placemark.name;
    
    // parsing all other info from the description
    IGHTMLDocument *doc = [[IGHTMLDocument alloc] initWithHTMLString:placemark.descriptionValue
                                                               error:nil];
    kiez.identifier = [self getValueForKey:@"FID" fromHTML:doc];
    kiez.district = [self getValueForKey:@"BEZNAME" fromHTML:doc];
    kiez.area = [self getValueForKey:@"BZRNAME" fromHTML:doc];
    kiez.sizeInHa = [[[self getValueForKey:@"FLAECHE_HA" fromHTML:doc] stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue];
    
    return kiez;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, id: %@, name: %@, district: %@, area: %@, size: %f",
            [super description], self.identifier, self.name, self.district, self.area, self.sizeInHa];
}

@end
