//
//  NKTradeViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 15.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKTradeViewController.h"

@implementation NKTradeViewController

#pragma mark - View Controller lyfe cycle -

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.screenName = @"Trade View";
}

@end
