//
//  AppCell.m
//  ActiveApps
//
//  Created by Yuriy Holovatskyi on 12/02/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AppCell.h"

@interface AppCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation AppCell

- (void)prepareForReuse
{
    self.imageView.image = nil;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.text = @"";
}

- (void)setAppParserElement:(AppsParserElement *)appParserElement
{
    _appParserElement = appParserElement;
    
    self.nameLabel.text = appParserElement.name;
    
    if (appParserElement.isActive) {
        self.nameLabel.backgroundColor = [UIColor greenColor];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [[RestManager sharedManager] getImageForAppWithPID:appParserElement.pid size:CGRectGetWidth(self.frame) completion:^(UIImage *image, NSError *error) {
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.imageView.image = image;
            });
        }
    }];
}


@end
