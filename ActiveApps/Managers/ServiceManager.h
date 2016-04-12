//
//  ServiceManager.h
//  ActiveApps
//
//  Created by Yuriy Holovatskyi on 12/01/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServiceManagerProtocol <NSObject>

@optional

- (void)serviceManagerProtocolDidFindServices;
- (void)serviceManagerProtocolDidReceiveApps;

@end

@interface ServiceManager : NSObject

@property (strong, nonatomic) NSNetService *currentService;

@property (strong, nonatomic) NSMutableArray *services;
@property (strong, nonatomic) NSArray *apps;

@property (strong, nonatomic) id<ServiceManagerProtocol> delegate;

+ (instancetype)sharedManager;

- (void)searchForServices;
- (void)resolveService:(NSNetService *)service;

@end
