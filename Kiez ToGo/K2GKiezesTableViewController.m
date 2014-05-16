//
//  K2GKiezesTableViewController.m
//  Kiez ToGo
//
//  Created by Christian Beer on 16.05.14.
//  Copyright (c) 2014 kiez e.V. GmbH (i.G.). All rights reserved.
//

#import "K2GKiezesTableViewController.h"

#import "K2GKiezManager.h"
#import "K2GKiez.h"


static NSString * const kKiezCellReuseIdentifier = @"KiezCell";


@interface K2GKiezesTableViewController ()

@end

@implementation K2GKiezesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"K2GKiezTableViewCell" bundle:nil]
         forCellReuseIdentifier:kKiezCellReuseIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [K2GKiezManager defaultManager].districts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *district = [K2GKiezManager defaultManager].districts[section];
    NSArray *kiezes = [[K2GKiezManager defaultManager] kiezesByDistricts][district];
    return kiezes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *district = [K2GKiezManager defaultManager].districts[section];
    return district;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kKiezCellReuseIdentifier forIndexPath:indexPath];
    
    NSString *district = [K2GKiezManager defaultManager].districts[indexPath.section];
    NSArray *kiezes = [[K2GKiezManager defaultManager] kiezesByDistricts][district];
    K2GKiez *kiez = kiezes[indexPath.row];
    cell.textLabel.text = kiez.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *district = [K2GKiezManager defaultManager].districts[indexPath.section];
    NSArray *kiezes = [[K2GKiezManager defaultManager] kiezesByDistricts][district];
    K2GKiez *kiez = kiezes[indexPath.row];
    
    [self.delegate kiezesController:self didSelectKiez:kiez];    
}

@end
