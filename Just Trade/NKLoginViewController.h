//
//  NKLoginViewController.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 14.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKLoginTextView.h"
#import "GAITrackedViewController.h"

@interface NKLoginViewController : GAITrackedViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NKLoginTextView *apiKeyTextView;
@property (weak, nonatomic) IBOutlet NKLoginTextView *apiSecretTextView;

- (IBAction)loginTouched:(UIButton *)sender;

@end
