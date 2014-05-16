//
//  K2GFoursquareVenueCell.m
//  Kiez ToGo
//
//  Created by Thomas Visser on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "K2GFoursquareVenueCell.h"
#import <Tweaks/FBTweakInline.h>

@implementation K2GFoursquareVenueCell

- (void)awakeFromNib
{
    [self.gradeLabel layoutIfNeeded];
    
    self.gradeLabel.layer.cornerRadius = 20;
    self.gradeLabel.backgroundColor = [UIColor colorWithRed:0.997 green:0.000 blue:0.990 alpha:1.000];
    self.gradeLabel.textColor = [UIColor whiteColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    UIColor *targetColor = selected ? [UIColor colorWithWhite:0.930 alpha:1.000] : [UIColor clearColor];;
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = targetColor;
        }];
    } else {
        self.backgroundColor = targetColor;
    }
}

@end
