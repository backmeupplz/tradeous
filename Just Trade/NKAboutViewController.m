//
//  NKAboutViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKAboutViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "SWRevealViewController.h"
#import "MHCustomTabBarController.h"
#import "NKPurchaseHandler.h"
#import "Reachability.h"

@implementation NKAboutViewController

#pragma mark -
#pragma mark View Controller life cycle
#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!isPurchased) {
        [(MHCustomTabBarController *)self.revealViewController.frontViewController hideAd];
        
        CGRect frame = self.view.frame;
        frame.size.height += 50;
        self.view.frame = frame;
    } else {
        [self hidePurchasingElements];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.screenName = @"About View";
}

- (void)viewWillDisappear:(BOOL)animated {
    if (!isPurchased) {
        [(MHCustomTabBarController *)self.revealViewController.frontViewController showAd];
        
        CGRect frame = self.view.frame;
        frame.size.height -= 50;
        self.view.frame = frame;
    }
    
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark Buttons methods
#pragma mark -

- (IBAction)turnOffAddsTouched:(id)sender {
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
        [purchaseHandler purchaseProProduct];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Нет интернета!",nil)
                                                        message:NSLocalizedString(@"Вы должны подключиться к интернету, чтобы совершать покупки",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ясно!",nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)rateAppTouched:(id)sender {
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
        NSString* url = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=708061571&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Нет интернета!",nil)
                                                        message:NSLocalizedString(@"Пожалуйста, подключитесь к интернету, чтобы оценить наше приложение",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Хорошо!",nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)vibranceTouched:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://vibrance.ru"]];
}

- (IBAction)restorePurchasesTouched:(id)sender {
    [purchaseHandler restorePurchases];
}

#pragma mark -
#pragma mark General methods
#pragma mark -

- (void)hidePurchasingElements {
    // Change text
    self.howToTurnOffAdsTitleLabel.text = NSLocalizedString(@"Приложение куплено!",nil);
    self.HowToTurnOffAdsTextLabel.text = NSLocalizedString(@"Огромное спасибо за то, что нас поддержали! Вы внесли невероятный вклад в развитие Tradeous. Добро пожаловать в элитное сообщество трейдеров!",nil);
    
    // Change buttons
    CGRect frame = self.rateAppButton.frame;
    frame.origin.y = (isIphone35) ? 229 : 273;
    self.rateAppButton.frame = frame;
    self.rateAppButton.backgroundColor = self.turnOffAddsButton.backgroundColor;
    [self.rateAppButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rateAppButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    self.turnOffAddsButton.hidden = YES;
    
    self.restorePurchasesButton.hidden = YES;
}

@end
