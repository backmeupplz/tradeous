//
//  NKSideMenuViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKSideMenuViewController.h"
#import "DataFromServerManager.h"
#import "NKSideMenuCell.h"
#import "SWRevealViewController.h"
#import "NKMarketViewController.h"

@implementation NKSideMenuViewController
{
    NSDictionary *tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"Side Menu View";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (dataFromServerManager.ticker != nil)
        tableData = dataFromServerManager.ticker;
    
    [self.sideMenuTableView reloadData];
    [self startObserving];
    [self selectCurrentCurrency:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopObserving];
    
    [super viewWillDisappear:animated];
}

#pragma mark - KVO methods -

- (void)startObserving
{
    [dataFromServerManager addObserver:self forKeyPath:@"ticker" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)stopObserving {
    [dataFromServerManager removeObserver:self forKeyPath:@"ticker"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"ticker"]) {
        mainQueueStart
        tableData = change[NSKeyValueChangeNewKey];
        [self.sideMenuTableView reloadData];
        [self selectCurrentCurrency:NO];
        mainQueueEnd
    }
}

#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self selectCurrentCurrency:NO];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SideMenuCell";
    NKSideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.text = getUppercaseStringForPair(indexPath.row);
    cell.averagePriceLabel.text = roundString([tableData[getStringForPair(indexPath.row)][@"avg"] stringValue]);
    
    return cell;
}

#pragma mark - UITableViewDelegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dataFromServerManager.pair = indexPath.row;
}

#pragma mark - General Methods -

- (void)selectCurrentCurrency:(BOOL)onTop
{
    NSIndexPath *path = [NSIndexPath indexPathForItem:dataFromServerManager.pair inSection:0];
    UITableViewScrollPosition position = (onTop) ? UITableViewScrollPositionTop :UITableViewScrollPositionNone;
    [self.sideMenuTableView selectRowAtIndexPath:path animated:NO scrollPosition:position];
}

#pragma mark - Useful functions -

NSString *roundString(NSString *string)
{
    double number = [string doubleValue];
    return (number == 0) ? @"" : [NSString stringWithFormat:@"%.5f",number];
}

@end
