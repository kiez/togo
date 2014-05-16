//
//  K2GKiezManager.h
//  Kiez ToGo
//
//  Created by Ullrich Schäfer on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface K2GKiezManager : NSObject

+ (instancetype)defaultManager;

@property (readonly) NSArray *kiezes;

@property (readonly) NSArray *districts; // strings of district names
@property (readonly) NSDictionary *kiezesByDistricts; // string -> array

@end
