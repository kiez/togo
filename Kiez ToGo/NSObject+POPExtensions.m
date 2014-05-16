//
//  NSObject+POPExtensions.m
//  Kiez ToGo
//
//  Created by Thomas Visser on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "NSObject+POPExtensions.h"
#import <pop/POP.h>

@implementation NSObject (POPExtensions)

- (POPAnimation *) pop_animationForKey: (NSString *) key orInitializeWithBlock: (POPAnimation*(^)(void)) initBlock
{
    POPAnimation *anim = [self pop_animationForKey:key];
    if (! anim && initBlock) {
        anim = initBlock();
        [self pop_addAnimation:anim forKey:key];
    }
    
    return anim;
}

@end
