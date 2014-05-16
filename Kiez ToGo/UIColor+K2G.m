//
//  UICollor+K2G.m
//  Kiez ToGo
//
//  Created by Stanley Rost on 16.05.14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "UIColor+K2G.h"

@implementation UIColor (K2G)

+ (UIColor *)randomColor
{
  CGFloat hue        = (float)arc4random_uniform(1000)/1000.0;
  CGFloat saturation = 0.7;
  CGFloat brightness = 0.8;
  CGFloat alpha      = 1.0;

  return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

@end
