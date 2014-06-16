//
//  NKHistoryViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 07.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKHistoryViewController.h"
#import "DataFromServerManager.h"
#import "NKHistoryTableViewCell.h"

@implementation NKHistoryViewController {
    NSArray *historyTableData;
    
    NSDate *prevDate;
}

#pragma mark -
#pragma mark View Controller life cycle
#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    historyTableData = [self getTableDataFromTradesArray:dataFromServerManager.btcUsdTrades];
    [self.historyTableView reloadData];
    [self startObserving];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.screenName = @"History View";
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopObserving];
    
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark KVO methods
#pragma mark -

- (void)startObserving {
    [dataFromServerManager addObserver:self forKeyPath:@"btcUsdTrades" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)stopObserving {
    [dataFromServerManager removeObserver:self forKeyPath:@"btcUsdTrades"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"btcUsdTrades"]) {
        mainQueueStart
        historyTableData = [self getTableDataFromTradesArray:change[NSKeyValueChangeNewKey]];
        [self.historyTableView reloadData];
        mainQueueEnd
    }
}

- (NSArray *)getTableDataFromTradesArray:(NSArray *)trades {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    trades = [trades subarrayWithRange:NSMakeRange(0, 30)];
    
    for (int i = 0; i < trades.count; i++) {
        NSDictionary *trade = trades[i];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970: [trade[@"date"] doubleValue]];
        
        if (i == 0) {
            [result addObject:@{
             @"type" : @1,
             @"timestamp" : date}];
            
            prevDate = date;
            
            [result addObject:@{
             @"type": @2,
             @"trade" : trade}];
            
        } else {
            if ([self isSameMinuteWithDate1:prevDate date2:date]) {
                prevDate = date;
                [result addObject:@{
                 @"type": @2,
                 @"trade" : trade}];
            } else {
                [result addObject:@{
                 @"type" : @1,
                 @"timestamp" : date}];
                
                prevDate = date;
                
                [result addObject:@{
                 @"type": @2,
                 @"trade" : trade}];
            }
            
        }
    }
    return result;
}

#pragma mark -
#pragma mark UITableViewDataSource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return historyTableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *trade = historyTableData[[indexPath row]];
    
    NKHistoryTableViewCell *cell;
    if ([trade[@"type"] isEqual: @1]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCellHeader"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        cell.timeLabel.text = [formatter stringFromDate:trade[@"timestamp"]];
        [formatter setDateFormat:@"dd.MM.yyyy"];
        cell.dateLabel.text = [formatter stringFromDate:trade[@"timestamp"]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
        
        trade = trade[@"trade"];
        
        double btcAmount = [trade[@"amount"] doubleValue];
        double price = [trade[@"price"] doubleValue];
        double usdAmount = btcAmount * price;
        
        NSString *pair = getUppercaseStringForPair(dataFromServerManager.pair);
        
        cell.sellBuyImageView.highlighted = [trade[@"trade_type"] isEqualToString:@"ask"];
        cell.priceLabel.text = [trade[@"price"] stringValue];
        cell.currencyLabel.text = [pair substringFromIndex:4];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        btcAmount = round (btcAmount * 100000.0) / 100000.0;
        usdAmount = round (usdAmount * 100000.0) / 100000.0;
        cell.amountToTradeLabel.text = [NSString stringWithFormat:@"%@ %@", [formatter stringFromNumber:[NSNumber numberWithDouble:btcAmount]],[pair substringToIndex:3]];
        cell.amountToGetLabel.text = [NSString stringWithFormat:@"%@ %@", [formatter stringFromNumber:[NSNumber numberWithDouble:usdAmount]], [pair substringFromIndex:4]];
    }
    
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *trade = historyTableData[[indexPath row]];
    
    return ([trade[@"type"] isEqual: @1]) ? 22 : 90;
}

#pragma mark -
#pragma mark Buttons methods
#pragma mark -

- (IBAction)backTouched:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark General methods
#pragma mark -

- (BOOL)isSameMinuteWithDate1:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 minute] == [comp2 minute] &&
    [comp1 hour] == [comp2 hour] &&
    [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

@end
