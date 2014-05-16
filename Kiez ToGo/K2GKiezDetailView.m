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

- (void)awakeFromNib
{
    UIView *borderBetweenMapAndTable = [UIView new];
    borderBetweenMapAndTable.backgroundColor = [UIColor colorWithWhite:0.763 alpha:1.000];
    borderBetweenMapAndTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview: borderBetweenMapAndTable];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_mapView][borderBetweenMapAndTable(1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_mapView, borderBetweenMapAndTable)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[borderBetweenMapAndTable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(borderBetweenMapAndTable)]];
}

- (void)showOverviewAnimated: (BOOL)animated
{
    if (animated) {
        POPPropertyAnimation *mapViewHeightAnim = [self mapViewHeightAnimation];
        mapViewHeightAnim.toValue = @(CGRectGetHeight(self.frame));
    } else {
        self.mapViewHeightConstraint.constant = CGRectGetHeight(self.frame);
    }
}

- (void)showKiezDetailsAnimated: (BOOL)animated
{
    if (animated) {
        POPPropertyAnimation *mapViewHeightAnim = [self mapViewHeightAnimation];
        mapViewHeightAnim.toValue = @(235);
    } else {
        self.mapViewHeightConstraint.constant = 235;
    }
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
