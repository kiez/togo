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

@property (nonatomic, copy) NSArray *sortedDistricts;
@property (nonatomic, copy) NSDictionary *sortedKiezesByDistrict;

@end

@implementation K2GKiezesTableViewController

- (void)viewDidLoad
{
  self.title = @"Berlin Kiezes";
  
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"K2GKiezTableViewCell" bundle:nil]
         forCellReuseIdentifier:kKiezCellReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  NSArray *sortedDistricts = [[K2GKiezManager defaultManager].districts sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES] ]];
  
  self.sortedDistricts = sortedDistricts;
  
  NSMutableDictionary *sortedKiezesByDistrict = [NSMutableDictionary new];
  
  for (NSUInteger i = 0; i < [sortedDistricts count]; ++i)
  {
    NSString *district = sortedDistricts[i];
    
    NSArray *kiezes = [[K2GKiezManager defaultManager] kiezesByDistricts][district];
    NSArray *sortedKiezes = [kiezes sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ]];
    sortedKiezesByDistrict[district] = sortedKiezes;
  }
  
  self.sortedKiezesByDistrict = sortedKiezesByDistrict;
  
  [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sortedDistricts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *district = self.sortedDistricts[section];
    NSArray *kiezes = self.sortedKiezesByDistrict[district];
    return [kiezes count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *district = self.sortedDistricts[section];
    return district;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kKiezCellReuseIdentifier forIndexPath:indexPath];
    
    NSString *district = self.sortedDistricts[indexPath.section];
  NSArray *kiezes = self.sortedKiezesByDistrict[district];
    K2GKiez *kiez = kiezes[indexPath.row];
    cell.textLabel.text = kiez.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *district = self.sortedDistricts[indexPath.section];
    NSArray *kiezes = self.sortedKiezesByDistrict[district];
    K2GKiez *kiez = kiezes[indexPath.row];
    
    [self.delegate kiezesController:self didSelectKiez:kiez];    
}

@end
