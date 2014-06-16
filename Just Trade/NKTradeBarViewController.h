//
//  NKTradeBarViewController.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 15.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKProgressView.h"
#import "GAITrackedViewController.h"

@interface NKTradeBarViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UIView *tradeBarHeader;
@property (weak, nonatomic) IBOutlet UILabel *tradeBarTitleLabel;
@property (weak, nonatomic) IBOutlet NKProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *tradeBarBackgroundView;

- (void)startTrade;

- (void)setSuccess;
- (void)setError;
- (void)setNoConnection;

@end
