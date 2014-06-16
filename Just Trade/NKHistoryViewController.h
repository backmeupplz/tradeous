//
//  NKHistoryViewController.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 07.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface NKHistoryViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

- (IBAction)backTouched:(id)sender;

@end
