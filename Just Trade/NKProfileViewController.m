//
//  NKProfileViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKProfileViewController.h"

#define achievementImageSpacing 15
#define achievementImageOffset 15
#define achievementImageSpacing35 10
#define achievementImageOffset35 10

@implementation NKProfileViewController

#pragma mark -
#pragma mark ViewController Life Cycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self addAchievementsToScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.apiKeyLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsApiKey];
    self.apiSecretLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsApiSecret];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsApiKey] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsApiKey] isEqualToString:@""])
        [self performSegueWithIdentifier:@"SegueToLogin" sender:self];
    
    [self addAchievementsToScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.screenName = @"Profile View";
}

#pragma mark -
#pragma mark Buttons methods
#pragma mark -

- (IBAction)logoutTouched:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUserDefaultsApiKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUserDefaultsApiSecret];
    
    [self performSegueWithIdentifier:@"SegueToLogin" sender:self];
}

#pragma mark -
#pragma mark General methods
#pragma mark -

- (void)addAchievementsToScrollView {
    for (UIView *view in self.achievmentsScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    float imageOffset = (isIphone35) ? achievementImageOffset35 : achievementImageOffset;
    float imageSpacing = (isIphone35) ? achievementImageSpacing35 : achievementImageSpacing;
    
    NSArray *achievements = [self getOnlyUnlockedAchievements];
    float length = self.achievmentsScrollView.frame.size.height - (imageOffset * 2);
    
    float totalLength = ((achievements.count) * (length + imageSpacing)) - imageSpacing + (imageOffset * 2);
    self.achievmentsScrollView.contentSize = CGSizeMake(totalLength, self.achievmentsScrollView.frame.size.height);
    
    for (int i = 0; i < achievements.count; i++) {
        NSDictionary *achievement = achievements[i];
        UIImageView *achievementImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:achievement[@"image"]]];
        float x = imageOffset + i * (length + imageSpacing);
        float y = self.achievmentsScrollView.frame.size.height / 2 - length / 2;
        achievementImage.frame = CGRectMake(x,y,length,length);
        [self.achievmentsScrollView addSubview:achievementImage];
        
        achievementImage.highlighted = (i%2==0);
    }
}

- (NSArray *)getOnlyUnlockedAchievements {
    NSArray *achievements = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAchievements];
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *achievement in achievements) {
        if ([achievement[@"unlocked"] boolValue]) {
            [result addObject:achievement];
        }
    }
    return [result copy];
}

@end
