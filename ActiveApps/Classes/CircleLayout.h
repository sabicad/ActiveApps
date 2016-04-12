//
//  CircleLayout.h
//  CollectionViewLayouts
//
//  Created by Ramon Bartl on 25.05.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleLayout : UICollectionViewLayout

@property (assign, nonatomic) CGPoint center;
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) NSInteger cellCount;
@property (assign, nonatomic) NSInteger currentActiveIndex;

@end