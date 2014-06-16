//
//  NKFinancesViewController.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface NKFinancesViewController : GAITrackedViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *financesTableView;

- (IBAction)backTouched:(id)sender;

@end
