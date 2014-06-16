//
//  NKAchievementsViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKAchievementsViewController.h"
#import "NKAchievementCell.h"

@implementation NKAchievementsViewController {
    NSArray *tableData;
}

#pragma mark -
#pragma mark View Controller life cycle
#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    
    tableData = [self getUnlockedAchievementsFirst];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.screenName = @"Achievements View";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    tableData = [self getUnlockedAchievementsFirst];
}

#pragma mark -
#pragma mark NSTableViewDataSource methods
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *achievement = tableData[[indexPath row]];
    NKAchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AchievementCell"];
    UIImage *achievementImage = [UIImage imageNamed:achievement[@"image"]];
    
    
    cell.achievementImageView.image = achievementImage;
    cell.titleLabel.text = achievement[@"name"];
    cell.subtitleLabel.text = achievement[@"description"];
    
    if (![achievement[@"unlocked"] boolValue])
        cell.achievementImageView.image = [cell.achievementImageView.image tintedImageUsingColor:[UIColor colorWithWhite:1.0 alpha:0.3]];
    
    return cell;
}

#pragma mark -
#pragma mark Buttons methods
#pragma mark -

- (IBAction)backTouched:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)getUnlockedAchievementsFirst {
    NSMutableArray *achievements = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAchievements] mutableCopy];
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *achievement in achievements) {
        if ([achievement[@"unlocked"] boolValue]) {
            [result addObject:achievement];
        }
    }
    [achievements removeObjectsInArray:result];
    [result addObjectsFromArray:achievements];
    return [result copy];
}

@end

@implementation UIImage (Tint)

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor {
    UIGraphicsBeginImageContext(self.size);
    CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:drawRect];
    [tintColor set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceAtop);
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

@end
