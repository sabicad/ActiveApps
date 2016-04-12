//
//  RestManager.m
//  ActiveApps
//
//  Created by Yuriy Holovatskyi on 12/01/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "RestManager.h"
#import "AppsParserElement.h"

static NSString *const AppsString = @"/apps";
static NSString *const ImageString = @"/apps/%ld/icon/%ld.png";
static NSString *const ActivateString = @"/apps/%ld/activate";

@implementation RestManager

+ (instancetype)sharedManager
{
    static RestManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[RestManager alloc] init];
    });
    
    return sharedManager;
}

- (void)getAppsListWithCompletion:(void(^)(BOOL success, NSArray *items, NSError *error))completion
{
    if (!completion) {
        return;
    }
    
    NSNetService *service = [ServiceManager sharedManager].currentService;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%ld%@", service.hostName, (long)service.port, AppsString]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.serverKey] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {

            NSArray *apps = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

            if (apps.count) {
                apps = [AppsParserElement processListFromJsonArray:apps];
            }
            
            completion(!error, apps, error);
        } else {
            completion(false, @[], error);
        }
    }];
    
    [task resume];
}

- (void)getImageForAppWithPID:(NSUInteger)pid size:(CGFloat)size completion:(void(^)(UIImage *image, NSError *error))completion
{
    if (!completion) {
        return;
    }
    
    NSNetService *service = [ServiceManager sharedManager].currentService;
    
    NSString *imageEndString = [NSString stringWithFormat:ImageString, (long)pid, (long)size];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%ld%@", service.hostName, (long)service.port, imageEndString]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.serverKey] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            completion(image, error);
            
        } else {
            completion(nil, error);
        }
    }];
    
    [task resume];
}

- (void)setAppActiveWithPID:(NSUInteger)pid completion:(void(^)(BOOL success, NSError *error))completion
{
    if (!completion) {
        return;
    }
    
    NSNetService *service = [ServiceManager sharedManager].currentService;
    
    NSString *activateEndString = [NSString stringWithFormat:ActivateString, (long)pid];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%ld%@", service.hostName, (long)service.port, activateEndString]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

    [request setHTTPMethod:@"POST"];
    
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.serverKey] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

            completion([res[@"success"] boolValue], error);
            
        } else {
            completion(false, error);
        }
    }];
    
    [task resume];
}

@end
