//
//  NKHistoryTableViewCell.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKHistoryTableViewCell : UITableViewCell

// Header cell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

// Average cell
@property (weak, nonatomic) IBOutlet UIImageView *sellBuyImageView;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountToTradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountToGetLabel;

@end
