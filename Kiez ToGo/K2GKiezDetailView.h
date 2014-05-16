//
//  K2GKiezDetailView.h
//  Kiez ToGo
//
//  Created by Thomas Visser on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface K2GKiezDetailView : UIView

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mapViewHeightConstraint;

- (void)showOverviewAnimated: (BOOL)animated;
- (void)showKiezDetailsAnimated: (BOOL)animated;

@end
