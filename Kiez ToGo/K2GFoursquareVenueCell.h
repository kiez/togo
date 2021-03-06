//
//  K2GFoursquareVenueCell.h
//  Kiez ToGo
//
//  Created by Thomas Visser on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface K2GFoursquareVenueCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *gradeLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleType;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;

@end
