//
//  NKAchievementManager.m
//  Tradeous
//
//  Created by Nikita Kolmogorov on 23.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKAchievementManager.h"
#import "NKAchievementUnlockedViewController.h"

#define userDefaults [NSUserDefaults standardUserDefaults]
#define kAchievementPairsUsedSet @"kAchievementPairUsedSet"
#define kAchievementPairsUsedTimestamp @"kAchievementPairsUsedTimestamp"
#define kAchievementUseTime @"kAchievementUseTime"
#define kAchievementSellNumber @"kAchievementSellNumber"
#define kAchievementBuyNumber @"kAchievementBuyNumber"
#define kAchievementTradeNumber @"kAchievementTradeNumber"

@implementation NKAchievementManager

#pragma mark -
#pragma mark Singleton pattern
#pragma mark -

+ (NKAchievementManager *)sharedAchievementManager {
    static NKAchievementManager *sharedAchievementManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAchievementManager = [[self alloc] init];
    });
    return sharedAchievementManager;
}

- (id)init {
    self = [super init];
    if (self) {
        // Set achievements file to user defaults if previously wasn't set
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAchievements] == nil) {
            NSArray *achievements = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"achievements" ofType:@"plist"]];
            [[NSUserDefaults standardUserDefaults] setObject:achievements forKey:kUserDefaultsAchievements];
        }
        
        // Start tracking time for achievement 12
        [self startTrackingTime];
    }
    return self;
}

#pragma mark -
#pragma mark General methods
#pragma mark -

/**
 *  Method to unlock achievement by number
 *
 *  @param achievementNumber Number of achievement to unlock
 */
- (void)unlockAchievement:(int)achievementNumber {
    
    NSMutableArray *achievements = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAchievements] mutableCopy];
    NSMutableDictionary *achievement = [achievements[achievementNumber] mutableCopy];
    
    if (![achievement[@"unlocked"] boolValue]) {
        
        achievement[@"unlocked"] = @YES;
        achievements[achievementNumber] = achievement;
        [[NSUserDefaults standardUserDefaults] setObject:achievements forKey:kUserDefaultsAchievements];
        
        [self showAchievement:achievementNumber];
    }
    
}

/**
 *  Method to show achievement view overlaying the main window
 *
 *  @param achievementNumber Number of achievement to show
 */
- (void)showAchievement:(int)achievementNumber {
    // Get achievement VC
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    NSString *storyboardId = @"Achievement";
    NKAchievementUnlockedViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:storyboardId];
    
    // Fill achievement with data
    NSDictionary *achievement = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAchievements][achievementNumber];
    
    NSString *title = achievement[@"name"];
    NSString *description = achievement[@"description"];
    NSString *imageName = achievement[@"image"];
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    // Add view to window
    [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
    
    vc.titleLabel.text = title;
    vc.subtitleLabel.text = description;
    vc.achievementImageView.image = image;
}

/**
 *  Method to be called when something is sold
 *
 *  @param pair pair that was sold
 */
- (void)sold:(Pair)pair amount:(double)amount {
    [self madeTrade:pair amount:amount];
    
    // Try to unlock 14, 15, 16, 17
    int sellNumber = [[userDefaults objectForKey:kAchievementSellNumber] intValue];
    [userDefaults setObject:[NSNumber numberWithInt:sellNumber+1] forKey:kAchievementSellNumber];
    [userDefaults setObject:[NSNumber numberWithInt:0] forKey:kAchievementBuyNumber];
    if (sellNumber > 70)
        [self unlockAchievement:17];
    else if (sellNumber > 50)
        [self unlockAchievement:16];
    else if (sellNumber > 20)
        [self unlockAchievement:15];
    else if (sellNumber > 10)
        [self unlockAchievement:14];
}

/**
 *  Method to be called when something is bought
 *
 *  @param pair pair that was bought
 */
- (void)bought:(Pair)pair amount:(double)amount {
    [self madeTrade:pair amount:amount];
    
    // Try to unlock 18, 19, 20, 21
    int buyNumber = [[userDefaults objectForKey:kAchievementBuyNumber] intValue];
    [userDefaults setObject:[NSNumber numberWithInt: buyNumber+1] forKey:kAchievementBuyNumber];
    [userDefaults setObject:[NSNumber numberWithInt:0] forKey:kAchievementSellNumber];
    
    if (buyNumber > 70)
        [self unlockAchievement:21];
    else if (buyNumber > 50)
        [self unlockAchievement:20];
    else if (buyNumber > 20)
        [self unlockAchievement:19];
    else if (buyNumber > 10)
        [self unlockAchievement:18];
}

/**
 *  Method to be called when something traded
 *
 *  @param pair pair that was traded
 */
- (void)madeTrade:(Pair)pair amount:(double)amount {
    // Unlocks fisrt deal achievement
    [self unlockAchievement:7];
    
    // Unlocks currency
    switch (pair) {
        case btc_usd:
            [self unlockAchievement:0];
            [self unlockAchievement:3];
            break;
        case btc_eur:
            [self unlockAchievement:0];
            [self unlockAchievement:5];
            break;
        case btc_rur:
            [self unlockAchievement:0];
            [self unlockAchievement:4];
            break;
        case ltc_btc:
            [self unlockAchievement:0];
            [self unlockAchievement:1];
            break;
        case ltc_eur:
            [self unlockAchievement:1];
            [self unlockAchievement:5];
            break;
        case ltc_rur:
            [self unlockAchievement:1];
            [self unlockAchievement:4];
            break;
        case ltc_usd:
            [self unlockAchievement:1];
            [self unlockAchievement:3];
            break;
        case nmc_btc:
            [self unlockAchievement:0];
            break;
        case nmc_usd:
            [self unlockAchievement:3];
            break;
        case nvc_btc:
            [self unlockAchievement:0];
            [self unlockAchievement:2];
            break;
        case nvc_usd:
            [self unlockAchievement:2];
            [self unlockAchievement:3];
            break;
        case usd_rur:
            [self unlockAchievement:3];
            [self unlockAchievement:4];
            break;
        case eur_usd:
            [self unlockAchievement:3];
            [self unlockAchievement:5];
            break;
        case trc_btc:
            [self unlockAchievement:0];
            break;
        case ppc_btc:
            [self unlockAchievement:0];
            break;
        case ftc_btc:
            [self unlockAchievement:0];
            break;
            
        default:
            break;
    }
    
    // Try to unlock 8
    double timestamp = [[NSDate date] timeIntervalSince1970];
    /*double dayAgo = timestamp - 60*60*24;
    double achievementTimestamp = [[userDefaults objectForKey:kAchievementPairsUsedTimestamp] doubleValue];
    if (achievementTimestamp < dayAgo) {
        // Set timestamp
        [userDefaults setObject:[NSNumber numberWithDouble:timestamp] forKey:kAchievementPairsUsedTimestamp];
        // Clears set
        [userDefaults setObject:[NSMutableSet set] forKey:kAchievementPairsUsedSet];
    } else {
        if ([userDefaults objectForKey:kAchievementPairsUsedSet] == nil)
            [userDefaults setObject:[NSMutableSet set] forKey:kAchievementPairsUsedSet];
        [[userDefaults objectForKey:kAchievementPairsUsedSet] addObject:[NSNumber numberWithInt:pair]];

        if ([[userDefaults objectForKey:kAchievementPairsUsedSet] count] >= 16)
            [self unlockAchievement:8];
    }*/
    
    // Try to unlock 9
    if (pair == btc_usd) {
        if (amount < 5)
            [self unlockAchievement:9];
        if (amount > 10)
            [self unlockAchievement:10];
        if (amount > 100)
            [self unlockAchievement:11];
    }
    
    // Try to unlock 22
    int tradeNumber = [[userDefaults objectForKey:kAchievementTradeNumber] intValue];
    if (tradeNumber < 50)
        [userDefaults setObject:[NSNumber numberWithInt: tradeNumber+1] forKey:kAchievementTradeNumber];
    else
        [self unlockAchievement:22];
    
    // Try to unlock 23
    if (fmod(timestamp,(60*60*24)) >= (60*60*4) && fmod(timestamp,(60*60*24)) <= (60*60*5)) {
        [self unlockAchievement:23];
    }
    
}

- (void)startTrackingTime {
    double timestamp = [[NSDate date] timeIntervalSince1970];
    [userDefaults setObject:[NSNumber numberWithDouble:timestamp] forKey:kAchievementUseTime];
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkUseTime) userInfo:nil repeats:YES];
}

- (void)checkUseTime {
    double achievementTimestamp = [[userDefaults objectForKey:kAchievementUseTime] doubleValue];
    double timestamp = [[NSDate date] timeIntervalSince1970];
    
    if (timestamp - achievementTimestamp > 60*60*24)
        [self unlockAchievement:12];
}

@end
