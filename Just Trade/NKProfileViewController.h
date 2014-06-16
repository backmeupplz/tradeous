//
//  NKProfileViewController.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface NKProfileViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UILabel *apiKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *apiSecretLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *achievmentsScrollView;

- (IBAction)logoutTouched:(UIButton *)sender;

@end
