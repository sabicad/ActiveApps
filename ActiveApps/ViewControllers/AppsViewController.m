//
//  AppsViewController.m
//  ActiveApps
//
//  Created by Yuriy Holovatskyi on 12/01/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AppsViewController.h"
#import "AppCell.h"
#import "AppsParserElement.h"
#import "CircleLayout.h"

@interface AppsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *appsCollectionData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet CircleLayout *collectionLayout;

@end

#pragma mark - Lifecycle

@implementation AppsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - ServiceManagerProtocol

- (void)serviceManagerProtocolDidReceiveApps
{
    self.appsCollectionData = [[NSMutableArray alloc] initWithArray:[ServiceManager sharedManager].apps];
    
    for (int i = 0; i < self.appsCollectionData.count - 1; i++) {
        AppsParserElement *element = self.appsCollectionData[i];
        
        if (element.active) {
            self.collectionLayout.currentActiveIndex = i;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.appsCollectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    AppCell *appCell = [[AppCell alloc]init];
    
    appCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AppCell" forIndexPath:indexPath];
    appCell.appParserElement = self.appsCollectionData[indexPath.row];
    
    cell = appCell;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppsParserElement *appParserElement = self.appsCollectionData[indexPath.row];
    
    if (!appParserElement.isActive) {
        self.collectionLayout.currentActiveIndex = indexPath.row;
                
        [self.appsCollectionData removeObjectAtIndex:indexPath.row];
        
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {

        }];
        
        
        [[RestManager sharedManager] setAppActiveWithPID:appParserElement.pid completion:^(BOOL success, NSError *error) {
            if (success) {
                self.appsCollectionData = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
                
                [[ServiceManager sharedManager] resolveService:[ServiceManager sharedManager].currentService];
            }
        }];
    }
}

@end
