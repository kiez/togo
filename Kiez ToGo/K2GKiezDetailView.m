//
//  K2GKiezDetailView.m
//  Kiez ToGo
//
//  Created by Thomas Visser on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "K2GKiezDetailView.h"
#import <pop/POP.h>
#import "NSObject+POPExtensions.h"

@implementation K2GKiezDetailView

- (void)showOverviewAnimated: (BOOL)animated
{
    POPPropertyAnimation *mapViewHeightAnim = [self mapViewHeightAnimation];
    mapViewHeightAnim.toValue = @(CGRectGetHeight(self.frame));
}

- (void)showKiezDetailsAnimated: (BOOL)animated
{
    POPPropertyAnimation *mapViewHeightAnim = [self mapViewHeightAnimation];
    mapViewHeightAnim.toValue = @(235);
}

- (POPPropertyAnimation *) mapViewHeightAnimation
{
    return (POPPropertyAnimation *)[self.mapViewHeightConstraint pop_animationForKey:@"height" orInitializeWithBlock:^POPAnimation *{
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        anim.springSpeed = 3;
        anim.springBounciness = 10;
        
        return anim;
    }];
}



@end
