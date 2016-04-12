//
//  RestManager.h
//  ActiveApps
//
//  Created by Yuriy Holovatskyi on 12/01/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RestManager : NSObject

@property (strong, nonatomic) NSString *serverKey;

+ (instancetype)sharedManager;

- (void)getAppsListWithCompletion:(void(^)(BOOL success, NSArray *items, NSError *error))completion;
- (void)getImageForAppWithPID:(NSUInteger)pid size:(CGFloat)size completion:(void(^)(UIImage *image, NSError *error))completion;
- (void)setAppActiveWithPID:(NSUInteger)pid completion:(void(^)(BOOL success, NSError *error))completion;

@end
