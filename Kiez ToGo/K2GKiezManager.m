//
//  K2GKiezManager.m
//  Kiez ToGo
//
//  Created by Ullrich Schäfer on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import <iOS-KML-Framework/KML.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


#import "K2GKiez.h"

#import "K2GKiezManager.h"


@interface K2GKiezManager ()
@property (readwrite) NSArray *kiezes;

@property (readwrite) NSArray *districts;
@property (readwrite) NSDictionary *kiezesByDistricts;

@end


@implementation K2GKiezManager

+ (instancetype)defaultManager
{
    static K2GKiezManager *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}


+ (NSArray *)parseKiezesFromKML
{
    NSString *kmlPath = [[NSBundle mainBundle] pathForResource:@"LOR-Planungsraeume" ofType:@"kml"];
    KMLRoot *kmlRoot = [KMLParser parseKMLAtPath:kmlPath];
    
    return [[[kmlRoot.placemarks rac_sequence] map:^K2GKiez *(KMLPlacemark *placemark) {
        return [K2GKiez kiezFromPlacemark:placemark];
    }] array];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _kiezes = [[self class] parseKiezesFromKML];
        
        _kiezesByDistricts = [(NSMutableDictionary *)[[self.kiezes rac_sequence] foldLeftWithStart:[NSMutableDictionary dictionary]
                                                                                            reduce:^NSMutableDictionary *(NSMutableDictionary *accumulator, K2GKiez *kiez) {
                                                                                                NSString *district = kiez.district;
                                                                                                NSArray *kiezes = [accumulator objectForKey:district] ?: [NSArray array];
                                                                                                [accumulator setObject:[kiezes arrayByAddingObject:kiez]
                                                                                                                forKey:district];
                                                                                                return accumulator;
                                                                                            }] copy];
        _districts = [self.kiezesByDistricts allKeys];
        
    }
    
    return self;
}

@end
