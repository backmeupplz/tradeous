//
//  NKBuySellCell.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 10.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKBuySellCell : UITableViewCell

// 1st cell
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;
@property (weak, nonatomic) IBOutlet UIButton *bigBuyButton;

@property (weak, nonatomic) IBOutlet UILabel *yourBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *minMaxPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *minMaxTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *amountTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@property (weak, nonatomic) IBOutlet UILabel *ordersTitleLabel;

// BuySellCell
@property (weak, nonatomic) IBOutlet UILabel *currencyAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *altCurrencyAmounLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
