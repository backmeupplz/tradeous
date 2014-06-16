//
//  NKAchievementManager.h
//  Tradeous
//
//  Created by Nikita Kolmogorov on 23.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#define achievementManager [NKAchievementManager sharedAchievementManager]

#import <Foundation/Foundation.h>
#import "BtceApiHandler.h"

@interface NKAchievementManager : NSObject

+ (NKAchievementManager *)sharedAchievementManager;

- (void)unlockAchievement:(int)achievementNumber;
- (void)sold:(Pair)pair amount:(double)amount;
- (void)bought:(Pair)pair amount:(double)amount;

@end
