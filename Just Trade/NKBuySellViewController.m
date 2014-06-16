//
//  NKBuySellViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 10.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKBuySellViewController.h"
#import "NKBuySellCell.h"
#import "DataFromServerManager.h"
#import "NKTradeBarViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"

@implementation NKBuySellViewController {
    NSArray *asksOrders;
    NSArray *bidsOrders;
    
    NKTradeBarViewController *tradeBarVC;
}

#pragma mark - View Controller Lyfe Cycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    asksOrders = dataFromServerManager.btcUsdOrders[@"asks"];
    bidsOrders = dataFromServerManager.btcUsdOrders[@"bids"];
    
    // Add editing listener to textfields
    [self.amountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.priceTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.screenName = @"Buy-Sell View";
    
    self.amountTitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Количество %@",nil),[getUppercaseStringForPair(dataFromServerManager.pair) substringToIndex:3]];
    self.priceTitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Цена за %@",nil),[getUppercaseStringForPair(dataFromServerManager.pair) substringToIndex:3]];
    
    if ((dataFromServerManager.pair == btc_usd ||
        dataFromServerManager.pair == btc_eur ||
        dataFromServerManager.pair == btc_rur ||
        dataFromServerManager.pair == ltc_btc ||
        dataFromServerManager.pair == nmc_btc ||
        dataFromServerManager.pair == nvc_btc ||
        dataFromServerManager.pair == trc_btc ||
        dataFromServerManager.pair == ppc_btc ||
        dataFromServerManager.pair == ftc_btc)||YES) {
        self.buySellButton.hidden = YES;
    } else {
        self.buySellButton.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startObserving];
    
    self.titleLabel.text = getUppercaseStringForPair(dataFromServerManager.pair);
    
    [self updateUI];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopObserving];
    
    [super viewDidDisappear:animated];
}

- (void)updateUI
{
    // Manage selection sell/buy buttons
    self.selectBuyButton.userInteractionEnabled = !self.isSell;
    self.selectBuyButton.selected = self.isSell;
    self.selectSellButton.userInteractionEnabled = self.isSell;
    self.selectSellButton.selected = !self.isSell;
    
    
    self.minMaxTitleLabel.text = (self.isSell) ? NSLocalizedString(@"Макс. цена",nil) : NSLocalizedString(@"Мин. цена",nil);
    
    self.ordersTitleLabel.text = (!self.isSell) ? NSLocalizedString(@"Ордера на продажу",nil) : NSLocalizedString(@"Ордера на покупку",nil);
    NSString *buttonTitle = (self.isSell) ? NSLocalizedString(@"Продать",nil) : NSLocalizedString(@"Купить",nil);
    [self.buySellButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    NSString *pair = getUppercaseStringForPair(dataFromServerManager.pair);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSArray *order = (self.isSell) ? bidsOrders[0] : asksOrders[0];
    NSNumber *price = [NSNumber numberWithDouble:[order[0] doubleValue]];
    self.minMaxPriceLabel.text = [NSString stringWithFormat:@"%@ %@", [formatter stringFromNumber:price], [pair substringFromIndex:4]];
    self.priceTextField.placeholder = [self.minMaxPriceLabel.text substringToIndex:self.minMaxPriceLabel.text.length-4];
    
    if (self.isSell) {
        double balance = [dataFromServerManager.balance[[[pair substringToIndex:3] lowercaseString]] doubleValue];
        
        self.balanceLabel.text = [NSString stringWithFormat:@"%@ %@",[formatter stringFromNumber:[NSNumber numberWithDouble:balance]], [pair substringToIndex:3]];
    } else {
        double balance = [dataFromServerManager.balance[[[pair substringFromIndex:4] lowercaseString]] doubleValue];
        
        self.balanceLabel.text = [NSString stringWithFormat:@"%@ %@",[formatter stringFromNumber:[NSNumber numberWithDouble:balance]], [pair substringFromIndex:4]];
    }
    
    [self changeScrollViewAndTableViewSizes];
}

#pragma mark - KVO methods -

- (void)startObserving
{
    [dataFromServerManager addObserver:self forKeyPath:@"btcUsdOrders" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)stopObserving
{
    [dataFromServerManager removeObserver:self forKeyPath:@"btcUsdOrders"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"btcUsdOrders"]) {
        mainQueueStart
            asksOrders = change[NSKeyValueChangeNewKey][@"asks"];
            bidsOrders = change[NSKeyValueChangeNewKey][@"bids"];
            [self.buySellTableView reloadData];
            [self updateUI];
        mainQueueEnd
    }
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.isSell) ? bidsOrders.count : asksOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId1 = @"BuySellCell";
    NKBuySellCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
    
    NSArray *order = (self.isSell) ? bidsOrders[[indexPath row]] : asksOrders[[indexPath row]];
    
    double price = [order[0] doubleValue];
    double amount = [order[1] doubleValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *pair = getUppercaseStringForPair(dataFromServerManager.pair);
    cell.currencyAmountLabel.text = [NSString stringWithFormat:@"%@: %@",[pair substringToIndex:3],[formatter stringFromNumber:[NSNumber numberWithDouble:amount]]];
    cell.altCurrencyAmounLabel.text = [NSString stringWithFormat:@"%@: %@",[pair substringFromIndex:4],[formatter stringFromNumber:[NSNumber numberWithDouble:price*amount]]];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithDouble:price]]];
    
    if (!(indexPath.row%2)) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        cell.contentView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:245.0/255.0 alpha:1.0f];
    }
    
    return cell;
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    double amount = [self.amountTextField.text doubleValue];
    double price = [self.priceTextField.text doubleValue];
    
    NSString *pair = getUppercaseStringForPair(dataFromServerManager.pair);
    pair = [pair substringFromIndex:4];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *total = [NSNumber numberWithDouble:amount*price];
    NSNumber *fee = [NSNumber numberWithDouble:amount*price*0.002];
    
    NSString *totalString = [formatter stringFromNumber:total];
    NSString *feeString = [formatter stringFromNumber:fee];
    
    self.totalLabel.text = [NSString stringWithFormat:@"%@ %@", totalString, pair];
    self.feeLabel.text = [NSString stringWithFormat:@"%@ %@", feeString, pair];
}

#pragma mark - Buttons methods -

- (IBAction)backTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseSellTouched:(id)sender
{
    self.isSell = YES;
    [self.buySellTableView reloadData];
    [self updateUI];
}

- (IBAction)chooseBuyTouched:(id)sender
{
    self.isSell = NO;
    [self.buySellTableView reloadData];
    [self updateUI];
}

- (IBAction)calculateTouched:(id)sender
{
    if (self.amountTextField.text == nil || [self.amountTextField.text isEqualToString:@""] || self.amountTextField.text.intValue <= 0) {
        NSArray *order = (self.isSell) ? bidsOrders[0] : asksOrders[0];
        self.priceTextField.text = [order[0] stringValue];
    } else {
        self.priceTextField.text = [self getWeightedPriceForAmount:self.amountTextField.text];
    }
}

- (IBAction)buySellTouched:(id)sender
{
    NSString *rate = self.priceTextField.text;
    NSString *amount = self.amountTextField.text;
    
    BOOL shouldBeOk = YES;
    if ((rate.doubleValue <= 0) || [rate isEqualToString:@""]) {
        [self.priceTextField addRedBorder];
        shouldBeOk = NO;
    } else {
        [self.priceTextField removeRedBorder];
    }
    if ((amount.doubleValue <= 0) || [amount isEqualToString:@""]) {
        [self.amountTextField addRedBorder];
        shouldBeOk = NO;
    } else {
        [self.amountTextField removeRedBorder];
    }
    
    if (!shouldBeOk)
        return;
    
    // Get a trade bar vc
    NSString *storyboardId = @"ProgressBar";
    tradeBarVC = [[UIApplication sharedApplication].keyWindow.rootViewController.storyboard instantiateViewControllerWithIdentifier:storyboardId];
    
    // Add view from trade bar vc to current window to overlay
    [[UIApplication sharedApplication].keyWindow addSubview:tradeBarVC.view];
    
    [tradeBarVC startTrade];
    
    tradeQueueStart
        BOOL tradeWasOk;
        if (self.isSell)
            tradeWasOk = [dataFromServerManager.btceApiHandler sellPair:dataFromServerManager.pair atRate:rate andAmount:amount];
        else
            tradeWasOk = [dataFromServerManager.btceApiHandler buyPair:dataFromServerManager.pair atRate:rate andAmount:amount];
        mainQueueStart
            if (tradeWasOk)
                [tradeBarVC setSuccess];
            else
                [tradeBarVC setError];
        mainQueueEnd
    tradeQueueEnd
}

#pragma mark - General methods -

- (void)changeScrollViewAndTableViewSizes
{
    // Change table view size
    CGRect frame = self.buySellTableView.frame;
    frame.size.height = self.buySellTableView.contentSize.height;
    self.buySellTableView.frame = frame;
    
    // Change scroll view content size
    self.mainScrollView.contentSize = CGSizeMake(320, frame.origin.y+frame.size.height);
}

- (NSString *)getWeightedPriceForAmount:(NSString *)amountString
{
    double totalAmount = [amountString doubleValue];
    double threshold = totalAmount;
    
    double moneySpent = 0.0;
    NSArray *orders = (self.isSell) ? bidsOrders : asksOrders;
    for (NSArray *order in orders) {
        double price = [order[0] doubleValue];
        double amount = [order[1] doubleValue];
        
        if (threshold - amount > 0) {
            moneySpent += amount * price;
            threshold -= amount;
        } else if (threshold - amount == 0) {
            moneySpent += amount * price;
            threshold -= amount;
            break;
        } else if (threshold - amount < 0) {
            moneySpent += threshold * price;
            break;
        }
    }
    
    double weightedPrice = moneySpent / totalAmount;
    
    return [NSString stringWithFormat:@"%.3f", weightedPrice];
}

@end
