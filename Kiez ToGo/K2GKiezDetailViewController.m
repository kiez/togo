//
//  K2GKiezDetailViewController.m
//  Kiez ToGo
//
//  Created by Ullrich Schäfer on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "K2GKiezDetailViewController.h"

#import "K2GFoursquareManager.h"


@interface K2GKiezDetailViewController ()

@end

@implementation K2GKiezDetailViewController

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
                                                       handler:^(BOOL success, id result) {
                                                           if (success) {
                                                               NSLog(@"success: %@", result);
                                                           } else {
                                                               NSLog(@"!!! failed: %@", result);
                                                           }
                                                       }];
}

@end
