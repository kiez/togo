//
//  K2GKiezesTableViewController.h
//  Kiez ToGo
//
//  Created by Christian Beer on 16.05.14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import <UIKit/UIKit.h>

@class K2GKiezesTableViewController;
@class K2GKiez;


@protocol K2GKiezesTableViewControllerDelegate <NSObject>

- (void) kiezesController:(K2GKiezesTableViewController*)ctrl didSelectKiez:(K2GKiez*)kiez;

@end

@interface K2GKiezesTableViewController : UITableViewController

@property (nonatomic, weak) id<K2GKiezesTableViewControllerDelegate> delegate;

@end
