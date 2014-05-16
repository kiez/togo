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
    self.gradeLabel.backgroundColor = [self tintColor];
    self.gradeLabel.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
