//
//  NKAchievementUnlockedViewController.m
//  Tradeous
//
//  Created by Nikita Kolmogorov on 25.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKAchievementUnlockedViewController.h"

@implementation NKAchievementUnlockedViewController

#pragma mark - View Controller Lyfe Cycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Place header on the right place
    CGRect frame = self.headerView.frame;
    frame.origin.y = -self.headerView.frame.size.height;
    self.headerView.frame = frame;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self animateHeader];
}

#pragma mark - General methods -

- (void)animateHeader
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.headerView.frame;
        frame.origin.y = 0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) frame.origin.y -= 20;
        self.headerView.frame = frame;
    } completion:^(BOOL finished) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideHeader) userInfo:nil repeats:NO];
    }];
}

- (void)hideHeader
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

@end
