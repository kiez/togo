//
//  NSObject+POPExtensions.h
//  Kiez ToGo
//
//  Created by Thomas Visser on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import <Foundation/Foundation.h>

@class POPAnimation;

@interface NSObject (POPExtensions)

- (POPAnimation *) pop_animationForKey: (NSString *) key orInitializeWithBlock: (POPAnimation*(^)(void)) initBlock;

@end
