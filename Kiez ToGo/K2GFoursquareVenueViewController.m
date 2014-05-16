//
//  K2GFoursquareVenueViewController.m
//  Kiez ToGo
//
//  Created by Ullrich Schäfer on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "K2GFoursquareVenueViewController.h"

@interface K2GFoursquareVenueViewController ()

@property (nonatomic,copy) NSString *venueIdentifier;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation K2GFoursquareVenueViewController

- (instancetype) init
{
    self = [self initWithVenueIdentifier:@"4ade123bf964a520d87221e3"];
    if (self) {
        
    }
    return self;
}

- (instancetype) initWithVenueIdentifier: (NSString *) identifier
{
    self = [super init];
    if (self) {
        _venueIdentifier = identifier;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *urlString = [NSString stringWithFormat:@"http://foursquare.com/venue/%@", self.venueIdentifier];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
