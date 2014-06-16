//
//  NKLoginViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 14.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKLoginViewController.h"
#import "NKAchievementManager.h"

@implementation NKLoginViewController

#pragma mark -
#pragma mark View Controller life cycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.screenName = @"Login View";
}

#pragma mark -
#pragma mark Buttons methods
#pragma mark -

- (IBAction)loginTouched:(UIButton *)sender {
    NSArray *textViews = @[self.apiKeyTextView,self.apiSecretTextView];
    
    BOOL shouldBeOk = YES;
    for (NKLoginTextView *view in textViews) {
        if ([view.text isEqualToString:@""]) {
            [view addRedBorder];
            shouldBeOk = NO;
        } else {
            [view removeRedBorder];
        }
    }
    if (!shouldBeOk)
        return;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.apiKeyTextView.text forKey:kUserDefaultsApiKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.apiSecretTextView.text forKey:kUserDefaultsApiSecret];
    
    [[NKAchievementManager sharedAchievementManager] unlockAchievement:13];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITextViewDelegate
#pragma mark -

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
