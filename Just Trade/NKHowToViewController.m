//
//  NKHowToViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 14.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKHowToViewController.h"

@implementation NKHowToViewController

#pragma mark - View Controller life cycle -

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.screenName = @"How-To View";
}

#pragma mark - Buttons methods -

- (IBAction)btceComTouched:(id)sender
{
    NSString *url = @"http://www.btc-e.com";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction)understoodTouched:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
