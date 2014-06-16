//
//  NKFinancesViewController.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 08.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKFinancesViewController.h"
#import "DataFromServerManager.h"
#import "NKFinancesCell.h"

@implementation NKFinancesViewController {
    NSArray *tableData;
}

#pragma mark -
#pragma mark View Controller life cycle
#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    tableData = [self getTableDataFromBalance:dataFromServerManager.balance];
    [self.financesTableView reloadData];
    [self startObserving];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.screenName = @"Balance View";
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopObserving];
    
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark KVO methods
#pragma mark -

- (void)startObserving {
    [dataFromServerManager addObserver:self forKeyPath:@"balance" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)stopObserving {
    [dataFromServerManager removeObserver:self forKeyPath:@"balance"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"balance"]) {
        tableData = [self getTableDataFromBalance:change[NSKeyValueChangeNewKey]];
        [self.financesTableView reloadData];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FinancesCell";
    NKFinancesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.currencyTittleLabel.text = [tableData[[indexPath row]][@"name"] uppercaseString];
    cell.currencySmallTitleLabel.text = [tableData[[indexPath row]][@"name"] uppercaseString];
    cell.amountTitleLabel.text = [tableData[[indexPath row]][@"amount"] stringValue];
    
    return cell;
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

- (NSArray *)getTableDataFromBalance:(NSDictionary *)balance {
    NSMutableArray *tempBalance = [NSMutableArray array];
    for (NSString *key in [balance allKeys]) {
        NSNumber *amount = balance[key];
        
        [tempBalance addObject:@{@"name" : key,
                                @"amount" : amount}];
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO];
    [tempBalance sortUsingDescriptors:@[sort]];
    return tempBalance;
}

@end
