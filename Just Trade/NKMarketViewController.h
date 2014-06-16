//
//  NKMarketViewController.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 07.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKCandleGraph.h"
#import "GAITrackedViewController.h"
#import "SWRevealViewController.h"

@interface NKMarketViewController : GAITrackedViewController <SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (weak, nonatomic) IBOutlet NKCandleGraph *graph;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *buyButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellButtonLabel;

- (IBAction)sideMenuTouched:(UIButton *)sender;

@end
