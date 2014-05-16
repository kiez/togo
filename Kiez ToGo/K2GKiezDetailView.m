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
    POPPropertyAnimation *mapViewAnim = [self mapViewFrameAnimation];
    CGRect currentMapViewFrame = self.mapView.frame;
    mapViewAnim.toValue = [NSValue valueWithCGRect:CGRectMake(currentMapViewFrame.origin.x, currentMapViewFrame.origin.y, currentMapViewFrame.size.width, CGRectGetHeight(self.frame))];
    
    POPPropertyAnimation *tableViewAnim = [self tableViewFrameAnimation];
    tableViewAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 0)];
}

- (void)showKiezDetailsAnimated: (BOOL)animated
{
    POPPropertyAnimation *mapViewAnim = [self mapViewFrameAnimation];
    
    CGRect currentMapViewFrame = self.mapView.frame;
    CGRect newMapViewFrame = CGRectMake(currentMapViewFrame.origin.x, currentMapViewFrame.origin.y, currentMapViewFrame.size.width, 235);
    mapViewAnim.toValue = [NSValue valueWithCGRect:newMapViewFrame];
    
    POPPropertyAnimation *tableViewAnim = [self tableViewFrameAnimation];
    tableViewAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, CGRectGetHeight(newMapViewFrame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetHeight(newMapViewFrame))];
}

- (POPPropertyAnimation *) mapViewFrameAnimation
{
    return [self frameAnimationForView:self.mapView];
}

- (POPPropertyAnimation *) tableViewFrameAnimation
{
    return [self frameAnimationForView: self.tableView];
}

- (POPPropertyAnimation *) frameAnimationForView: (UIView *) view;
{
    return (POPPropertyAnimation *)[view pop_animationForKey:@"frame" orInitializeWithBlock:^POPAnimation *{
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.springSpeed = 3;
        anim.springBounciness = 10;
        
        return anim;
    }];
}



@end
