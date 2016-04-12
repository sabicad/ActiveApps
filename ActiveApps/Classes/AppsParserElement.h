//
//  AppsParser.h
//  ActiveApps
//
//  Created by Yuriy Holovatskyi on 12/01/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppsParserElement : NSObject

@property (assign, nonatomic, getter=isActive) BOOL active;
@property (assign, nonatomic) NSTimeInterval alive;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSUInteger pid;

+ (AppsParserElement *)processItemFromJSON:(NSDictionary *)json;
+ (NSArray *)processListFromJsonArray:(NSArray *)jsonArray;

@end
