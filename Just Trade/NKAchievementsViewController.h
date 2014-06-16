//
//  NKAchievementsViewController.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface NKAchievementsViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)backTouched:(id)sender;

@end


@interface UIImage (Tint)

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor;

@end