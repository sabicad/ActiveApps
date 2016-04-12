//
//  ServicesViewController.m
//  ActiveApps
//
//  Created by Yuriy Holovatskyi on 12/01/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "ServicesViewController.h"
#import "AppsViewController.h"

static NSString *const tableViewCellIdentifier = @"Cell";
static NSString *const appsSeque = @"appsSegue";

@interface ServicesViewController () <UITableViewDataSource, UITableViewDelegate, ServiceManagerProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSArray *servicesTableData;

@end

#pragma mark - Lifecycle

@implementation ServicesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    
    [ServiceManager sharedManager].delegate = self;
    [[ServiceManager sharedManager] searchForServices];
}

#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:appsSeque]) {
        AppsViewController *vc = segue.destinationViewController;
                
        [ServiceManager sharedManager].delegate = vc;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:appsSeque sender:self];

    [[ServiceManager sharedManager] resolveService:self.servicesTableData[indexPath.row]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.servicesTableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    NSNetService *service = self.servicesTableData[indexPath.row];
    cell.textLabel.text = service.name;
    
    if (indexPath.row == self.servicesTableData.count - 1) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
    }
    
    return cell;
}

#pragma mark - ServiceManagerProtocol

- (void)serviceManagerProtocolDidFindServices
{
    self.servicesTableData = [[ServiceManager sharedManager].services copy];
    [self.tableView reloadData];
}

@end
