//
//  K2GKiezDetailViewController.m
//  Kiez ToGo
//
//  Created by Ullrich Schäfer on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "K2GKiezDetailViewController.h"

#import "K2GFoursquareManager.h"

#import "K2GFSVenue.h"
#import "K2GFSLocation.h"


static NSString * const kFoursquareVenueCellReuseIdentifier = @"kFoursquareVenueCellReuseIdentifier";

@interface K2GKiezDetailViewController ()

@property (nonatomic) K2GKiezDetailView *view;

@end

@implementation K2GKiezDetailViewController
{
    NSArray *_venues;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[K2GFoursquareManager sharedInstance] requestVenuesAround:CLLocationCoordinate2DMake(52.546430, 13.361980)
                                                       handler:^(NSArray *venues, NSError *error) {
                                                           _venues = venues;
                                                               NSLog(@"success: %@", result);
                                                           [self.view.tableView reloadData];
                                                               NSLog(@"!!! failed: %@", result);
                                                           }
                                                       }];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    K2GFoursquareVenueCell *cell = [tableView dequeueReusableCellWithIdentifier:kFoursquareVenueCellReuseIdentifier];

    K2GFSVenue *venue = _venues[indexPath.row];
    cell.gradeLabel.text = @"00";
    cell.titleLabel.text = venue.name;
    cell.titleType.text = venue.primaryCategoryName;
    cell.addressLabel.text = venue.location.address;
    
    return cell;
}

@end
