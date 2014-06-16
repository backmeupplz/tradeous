//
//  NKMarketViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 07.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKMarketViewController.h"
#import "NKSideMenuViewController.h"
#import "DataFromServerManager.h"
#import "NKBuySellViewController.h"
#import "Reachability.h"
#import "NKAppDelegate.h"
#import "NKAchievementManager.h"

@implementation NKMarketViewController

#pragma mark - View Controller life cycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate = self;
    
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        [(NKAppDelegate *)[UIApplication sharedApplication].delegate showNoConnectionView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.graph drawValues:dataFromServerManager.btcUsdTrades];
    [self startObserving];
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Unlock fisrt launch achievement
    [[NKAchievementManager sharedAchievementManager] unlockAchievement:6];
    
    self.screenName = @"Market (Main) View";
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopObserving];
    
    [super viewDidDisappear:animated];
}

#pragma mark - KVO methods -

- (void)startObserving
{
    [dataFromServerManager addObserver:self forKeyPath:@"btcUsdTrades" options:NSKeyValueObservingOptionNew context:nil];
    [dataFromServerManager addObserver:self forKeyPath:@"pair" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)stopObserving
{
    [dataFromServerManager removeObserver:self forKeyPath:@"btcUsdTrades"];
    [dataFromServerManager removeObserver:self forKeyPath:@"pair"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"btcUsdTrades"]) {
        mainQueueStart
            [self.graph drawValues:change[NSKeyValueChangeNewKey]];
        mainQueueEnd
    } else if ([keyPath isEqualToString:@"pair"]) {
        mainQueueStart
            [self.graph clean];
            [self updateUI];
        mainQueueEnd
    }
}

#pragma mark - SWRevealViewControllerDelegate -

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position
{
    switch (position) {
        case FrontViewPositionLeft:
            self.sideMenuButton.selected = NO;
            break;
        case FrontViewPositionRight:
            self.sideMenuButton.selected = YES;
            break;
        default:
            break;
    }
}

#pragma mark - Buttons methods -

- (IBAction)sideMenuTouched:(UIButton *)sender
{
    [self.revealViewController revealToggle:sender];
}

#pragma mark - General Methods -

- (void)updateUI
{
    self.titleLabel.text = getUppercaseStringForPair(dataFromServerManager.pair);
    
    if ((dataFromServerManager.pair == btc_usd ||
        dataFromServerManager.pair == btc_eur ||
        dataFromServerManager.pair == btc_rur ||
        dataFromServerManager.pair == ltc_btc ||
        dataFromServerManager.pair == nmc_btc ||
        dataFromServerManager.pair == nvc_btc ||
        dataFromServerManager.pair == trc_btc ||
        dataFromServerManager.pair == ppc_btc ||
        dataFromServerManager.pair == ftc_btc)||YES) {
        self.buyButtonLabel.text = NSLocalizedString(@"Sell orders", nil);
        self.sellButtonLabel.text = NSLocalizedString(@"Buy orders", nil);
    } else {
        self.buyButtonLabel.text = NSLocalizedString(@"Buy", nil);
        self.sellButtonLabel.text = NSLocalizedString(@"Sell", nil);
    }
}

#pragma mark - Segue methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToSell"]) {
        NKBuySellViewController *dest = segue.destinationViewController;
        dest.isSell = YES;
    } else if ([segue.identifier isEqualToString:@"SegueToBuy"]) {
        NKBuySellViewController *dest = segue.destinationViewController;
        dest.isSell = NO;
    }
}

@end
