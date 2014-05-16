//
//  K2GAppDelegate.m
//  Kiez ToGo
//
//  Created by Ullrich Schäfer on 16/05/14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "K2GKiezManager.h"

#import "K2GKiezDetailViewController.h"

#import "K2GAppDelegate.h"
#import "K2GFoursquareManager.h"

#import "K2GKiezesTableViewController.h"

@interface K2GAppDelegate () <K2GKiezesTableViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) K2GKiezDetailViewController *kiezesDetailViewCtrl;

@end


@implementation K2GAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    K2GKiezDetailViewController *kiezesDetailViewCtrl = [K2GKiezDetailViewController new];
    K2GKiezesTableViewController *kiezesTableViewCtrl = [K2GKiezesTableViewController new];
    kiezesTableViewCtrl.delegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] init];
    navController.viewControllers = @[kiezesTableViewCtrl, kiezesDetailViewCtrl];
    self.window.rootViewController = navController;
    
    self.kiezesDetailViewCtrl = kiezesDetailViewCtrl;
    self.navigationController = navController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor colorWithRed:0.997 green:0.000 blue:0.990 alpha:1.000];
    [self.window makeKeyAndVisible];
    
    [[K2GFoursquareManager sharedInstance] setupFoursquare];
    
    
    
    // just to test
    [K2GKiezManager defaultManager];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Foursquare

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[K2GFoursquareManager sharedInstance] handleURL:url];
}


#pragma mark - K2GKiezesTableViewControllerDelegate

- (void)kiezesController:(K2GKiezesTableViewController *)ctrl didSelectKiez:(K2GKiez *)kiez
{
    [self.kiezesDetailViewCtrl zoomToKiez:kiez];
    [self.navigationController pushViewController:self.kiezesDetailViewCtrl animated:YES];
}

@end
