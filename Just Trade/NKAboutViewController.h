//
//  NKAboutViewController.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface NKAboutViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UILabel *howToTurnOffAdsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *HowToTurnOffAdsTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *turnOffAddsButton;
@property (weak, nonatomic) IBOutlet UIButton *rateAppButton;
@property (weak, nonatomic) IBOutlet UIButton *restorePurchasesButton;

- (IBAction)turnOffAddsTouched:(id)sender;
- (IBAction)rateAppTouched:(id)sender;
- (IBAction)vibranceTouched:(id)sender;
- (IBAction)restorePurchasesTouched:(id)sender;


@end
