//
//  ServiceManager.m
//  ActiveApps
//
//  Created by Yuriy Holovatskyi on 12/01/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "ServiceManager.h"

static NSString *const serviceType = @"_mch15._tcp.";
static NSString *const serviceDomain = @"local.";

@interface ServiceManager () <NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property (strong, nonatomic) NSNetServiceBrowser *netBrowser;
@property (strong, nonatomic) NSTimer *timer;

@end

#pragma mark - LifeCycle

@implementation ServiceManager

+ (instancetype)sharedManager
{
    static ServiceManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[ServiceManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Public

- (void)searchForServices
{
    self.services = [[NSMutableArray alloc] init];
    
    self.netBrowser = [[NSNetServiceBrowser alloc] init];
    self.netBrowser.delegate = self;
    
    [self.netBrowser searchForServicesOfType:@"_mch15._tcp." inDomain:@"local."];
}

- (void)resolveService:(NSNetService *)service
{
    self.currentService = service;
    self.currentService.delegate = self;
    
    [self.currentService resolveWithTimeout:kServiceResolveTimeInterval];
}

#pragma mark - Private

- (void)getAppsList
{
    [self.timer invalidate];
    self.timer = nil;
    
    __weak typeof(self) weakSelf = self;

    [[RestManager sharedManager] getAppsListWithCompletion:^(BOOL success, NSArray *items, NSError *error) {
        if (success) {
            weakSelf.apps = items;
            
            if ([weakSelf.delegate respondsToSelector:@selector(serviceManagerProtocolDidReceiveApps)]) {
                [weakSelf.delegate serviceManagerProtocolDidReceiveApps];
            }
            
        } else {
            NSLog(@"List not received");
        }
        
        [self launchTimer];
    }];
}

- (void)launchTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                      target:self
                                                    selector:@selector(getAppsList)
                                                    userInfo:nil
                                                     repeats:NO];
    });
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    [self.services addObject:service];
    
    if (!moreComing) {
        if ([self.delegate respondsToSelector:@selector(serviceManagerProtocolDidFindServices)]) {
            [self.delegate serviceManagerProtocolDidFindServices];
        }
        
        [self.netBrowser stop];
    }
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    [sender stop];
    
    [self getAppsList];
}

@end