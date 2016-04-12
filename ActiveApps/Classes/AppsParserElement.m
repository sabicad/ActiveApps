//
//  AppsParser.m
//  ActiveApps
//
//  Created by Yuriy Holovatskyi on 12/01/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AppsParserElement.h"

@implementation AppsParserElement

+ (AppsParserElement *)processItemFromJSON:(NSDictionary *)json
{
    AppsParserElement *item = [[AppsParserElement alloc] init];
    
    item.active = [json[@"active"] boolValue];
    item.alive = [json[@"alive"] doubleValue];
    item.name = json[@"name"];
    item.pid = [json[@"pid"] unsignedIntegerValue];
    
    return item;
}

+ (NSArray *)processListFromJsonArray:(NSArray *)jsonArray
{
    NSMutableArray *result = [NSMutableArray new];
    
    for (NSDictionary *json in jsonArray) {
        [result addObject:[AppsParserElement processItemFromJSON:json]];
    }

    return result;
}

@end
