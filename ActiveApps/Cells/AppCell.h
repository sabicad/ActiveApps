//
//  AppCell.h
//  ActiveApps
//
//  Created by Yuriy Holovatskyi on 12/02/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppsParserElement.h"

@interface AppCell : UICollectionViewCell

@property (strong, nonatomic) AppsParserElement* appParserElement;

@end
