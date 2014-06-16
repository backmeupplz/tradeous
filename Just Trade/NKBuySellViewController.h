//
//  NKBuySellViewController.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 10.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKTextFieldWithPadding.h"
#import "GAITrackedViewController.h"

@interface NKBuySellViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

// UI properties
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UITableView *buySellTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectBuyButton;
@property (weak, nonatomic) IBOutlet UIButton *selectSellButton;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *minMaxTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *minMaxPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *amountTitleLabel;
@property (weak, nonatomic) IBOutlet NKTextFieldWithPadding *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet NKTextFieldWithPadding *priceTextField;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@property (weak, nonatomic) IBOutlet UIButton *buySellButton;

@property (weak, nonatomic) IBOutlet UILabel *ordersTitleLabel;

// Property to set manualy
@property BOOL isSell;

- (IBAction)backTouched:(id)sender;
- (IBAction)chooseSellTouched:(id)sender;
- (IBAction)chooseBuyTouched:(id)sender;

- (IBAction)calculateTouched:(id)sender;
- (IBAction)buySellTouched:(id)sender;

@end
