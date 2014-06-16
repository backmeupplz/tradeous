//
//  NKFinancesCell.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKFinancesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *currencyTittleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencySmallTitleLabel;

@end
