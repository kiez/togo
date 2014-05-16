//
//  K2GKiezDetailViewController.h
//  Kiez ToGo
//
//  Created by Ullrich Schäfer on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import <UIKit/UIKit.h>

#import "K2GKiezesTableViewController.h"

@class K2GKiez;


@interface K2GKiezDetailViewController : UIViewController

- (void)zoomToKiez:(K2GKiez*)kiez;

@end
