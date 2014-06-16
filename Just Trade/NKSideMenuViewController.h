//
//  NKSideMenuViewController.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface NKSideMenuViewController : GAITrackedViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sideMenuTableView;

@end
