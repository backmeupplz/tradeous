//
//  NKAppDelegate.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 07.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKAppDelegate.h"
#import "DataFromServerManager.h"
#import "GAI.h"
#import "NKPurchaseHandler.h"
#import "Reachability.h"
#import "NKAchievementManager.h"

@implementation NKAppDelegate {
    UIViewController *noConnectionVC;
}

#pragma mark -
#pragma mark Application Lifecycle
#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize data from server handler
    [DataFromServerManager sharedDataFromServerManager];
    
    // Initialize GA
    [self initializeGA];
    
    // Initialize purchase handler
    [NKPurchaseHandler sharedPurchaseHandler];
    
    // Start Reachability observation
    [self startReachabilityObservation];
    
    // Initialize achievement manager
    [NKAchievementManager sharedAchievementManager];
    
    return YES;
}

#pragma mark - General methods -

/**
 *  Method to initialize Google Analytics
 */
- (void)initializeGA {
    // Initialize tracker.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-43367175-2"];
}

- (void)startReachabilityObservation {
    // Get no connection VC
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    NSString *storyboardId = @"NoConnection";
    noConnectionVC = [mainStoryboard instantiateViewControllerWithIdentifier:storyboardId];
    
    // Setup reachability
    Reachability *internetConnection = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [internetConnection startNotifier];
}

- (void)reachabilityChanged:(NSNotification* )note {
    Reachability *reachability = [note object];
    
    if (reachability.isReachable) {
        [noConnectionVC.view removeFromSuperview];
    } else {
        [self showNoConnectionView];
    }
}

- (void)showNoConnectionView {
    if ([noConnectionVC.view superview] == nil)
        [[UIApplication sharedApplication].keyWindow addSubview:noConnectionVC.view];
}

@end
