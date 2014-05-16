//
//  KMLPlacemark+MapKit.m
//  KML+MapKit
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import <objc/runtime.h>
#import "KMLStyle.h"
#import "KMLIconStyle.h"
#import "KMLIcon.h"
#import "KMLMultiGeometry.h"
#import "KMLPlacemark+MapKit.h"

@implementation KMLPlacemark (MapKit)

- (BOOL)hasIcon
{
    KMLStyle *style = self.style;
    if (style
        && style.iconStyle
        && style.iconStyle.icon
        && style.iconStyle.icon.href) {
        return YES;
    }
    
    return NO;
}

- (UIImage *)icon
{
    UIImage *image = objc_getAssociatedObject(self, "kKMLPlacemarkIconImageKey");
    if (!image) {
        KMLStyle *style = self.style;
        if (style
            && style.iconStyle
            && style.iconStyle.icon
            && style.iconStyle.icon.href) {
            
            NSError *error = nil;
            NSURL *url = [NSURL URLWithString:style.iconStyle.icon.href];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            if (error) {
                DLog(@"error, %@", [error localizedDescription]);
                
                // Set dot image
                image = [UIImage imageNamed:@"dot.png"];
                
            } else {
                image = [UIImage imageWithData:data];

                // Shrink Google Earth placemark icons
                if (image.size.width == 64.f && image.size.height == 64.f) {
                    if ([UIScreen mainScreen].scale == 2.0) {
                        image = [UIImage imageWithCGImage:image.CGImage scale:2.f orientation:image.imageOrientation];
                    } else {
                        UIGraphicsBeginImageContext(CGSizeMake(32,32));
                        [image drawInRect:CGRectMake(0, 0, 32, 32)];
                        image = UIGraphicsGetImageFromCurrentImageContext();
                    }
                }
            }
            
            objc_setAssociatedObject(self, "kKMLPlacemarkIconImageKey", image, OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    return image;    
}

@end
