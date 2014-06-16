//
//  NKMarketButtonView.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 07.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKMarketButtonView.h"
#import "MHCustomTabBarController.h"
#import "SWRevealViewController.h"
#import "DataFromServerManager.h"

@implementation NKMarketButtonView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)]];
}

#pragma mark - General methods -

- (void)tapped
{
    if ([self.restorationIdentifier isEqualToString:@"buy"]) {
        
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsApiKey] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsApiKey] isEqualToString:@""]) {
//            [(MHCustomTabBarController *)self.delegate.revealViewController.frontViewController performSegueWithIdentifier:@"SegueToProfile" sender:[(MHCustomTabBarController *)self.delegate.revealViewController.frontViewController profileButton]];
//            return;
//        } else
            [self.delegate performSegueWithIdentifier:@"SegueToBuy" sender:self.delegate];
    } else if ([self.restorationIdentifier isEqualToString:@"sell"]) {
        
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsApiKey] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsApiKey] isEqualToString:@""]) {
//            [(MHCustomTabBarController *)self.delegate.revealViewController.frontViewController performSegueWithIdentifier:@"SegueToProfile" sender:[(MHCustomTabBarController *)self.delegate.revealViewController.frontViewController profileButton]];
//            return;
//        } else
            [self.delegate performSegueWithIdentifier:@"SegueToSell" sender:self.delegate];
    } else if ([self.restorationIdentifier isEqualToString:@"history"]) {
        [self.delegate performSegueWithIdentifier:@"SegueToHistory" sender:self.delegate];
    } else if ([self.restorationIdentifier isEqualToString:@"chat"]) {
        [self.delegate performSegueWithIdentifier:@"SegueToChat" sender:self.delegate];
    }
}

@end
