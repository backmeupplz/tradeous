//
//  NKTradeBarViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 15.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKTradeBarViewController.h"

@implementation NKTradeBarViewController {
    NSTimer *progressTimer;
    
    float progress;
}

#pragma mark -
#pragma mark View Controller life cycle
#pragma mark -

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.screenName = @"Trade Bar View";
}

#pragma mark -
#pragma mark General methods
#pragma mark -

- (void)startTrade {
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(incrementProgress) userInfo:Nil repeats:YES];
    [self showScene];
}

- (void)incrementProgress {
    progress += 1;
    
    if (progress > 100) {
        if (progressTimer.isValid)
            [progressTimer invalidate];
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        [self.progressView setProgress:progress];
    }];
}

- (void)setSuccess {
    if (progressTimer.isValid)
        [progressTimer invalidate];
    
    [self.progressView setSucceeded];
    self.tradeBarTitleLabel.text = NSLocalizedString(@"Сделка успешно завершена!",nil);
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideScene) userInfo:nil repeats:NO];
}

- (void)setError {
    if (progressTimer.isValid)
        [progressTimer invalidate];
    
    [self.progressView setError];
    self.tradeBarTitleLabel.text = NSLocalizedString(@"Какая-то ошибка, чувак",nil);
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideScene) userInfo:nil repeats:NO];
}

- (void)setNoConnection {
    if (progressTimer.isValid)
        [progressTimer invalidate];
    
    [self.progressView setNoConnection];
    self.tradeBarTitleLabel.text = NSLocalizedString(@"Нет соединения с сервером, попробуйте позже",nil);
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideScene) userInfo:nil repeats:NO];
}

- (void)showScene {
    [UIView animateWithDuration:0.5 animations:^{
        // Show background
        self.tradeBarBackgroundView.alpha = 1.0;
        
        // Show header
        self.tradeBarHeader.alpha = 1.0;
    }];
}

- (void)hideScene {
    [UIView animateWithDuration:0.5 animations:^{
        // Hide background
        self.tradeBarBackgroundView.alpha = 0.0;
        
        // Hide header
        self.tradeBarHeader.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

@end
