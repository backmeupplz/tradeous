//
//  DataFromServer.m
//  BTCEBot
//
//  Created by Nikita Kolmogorov on 14.06.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "DataFromServerManager.h"

@implementation DataFromServerManager {
    NSTimer *updater;
    BOOL isUpdateNeeded;
}

#pragma mark - Singleton pattern -

+ (DataFromServerManager *)sharedDataFromServerManager {
    static DataFromServerManager  *sharedDataFromServerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataFromServerManager = [[self alloc] init];
    });
    return sharedDataFromServerManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.btceApiHandler = [[BtceApiHandler alloc] init];
        self.pair = btc_usd;
        [self update];
        [self startUpdatingData];
    }
    return self;
}

#pragma mark - General methods -

- (void)startUpdatingData {
    isUpdateNeeded = YES;
    [self update];
    if (!updater.isValid)
        updater = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)stopUpdatingData {
    if (updater.isValid)
        [updater invalidate];
}

- (void)update {
    if (isUpdateNeeded) {
        isUpdateNeeded = NO;
        downloadQueueStart
        
        NSDictionary *info = [self.btceApiHandler getInfo];
        if (info != nil) {
            mainQueueStart
            self.openOrdersCount = info[@"openOrders"];
            self.transactionsCount = info[@"transactionCount"];
            self.apiRights = info[@"apiRights"];
            self.balance = info[@"funds"];
            mainQueueEnd
        }
        info = nil;
        
        NSDictionary *tempBtcUsdRate = [self.btceApiHandler getSellAndBuyRateForPair:self.pair];
        mainQueueStart
        if (tempBtcUsdRate != nil)
            self.btcUsdRate = tempBtcUsdRate;
        mainQueueEnd
        tempBtcUsdRate = nil;
        
        NSDictionary *tempBtcUsdOrders = [self.btceApiHandler getOrdersForPair:self.pair];
        mainQueueStart
        if (tempBtcUsdOrders != nil)
            if (![tempBtcUsdOrders isEqualToDictionary:self.btcUsdOrders])
                self.btcUsdOrders = tempBtcUsdOrders;
        mainQueueEnd
        tempBtcUsdOrders = nil;
        
        NSArray *tempBtcUsdTrades = [self.btceApiHandler getTradesForPair:self.pair];
        mainQueueStart
        if (tempBtcUsdTrades != nil)
            if (![tempBtcUsdTrades isEqualToArray:self.btcUsdTrades])
                self.btcUsdTrades = tempBtcUsdTrades;
        mainQueueEnd
        tempBtcUsdTrades = nil;
    
        NSDictionary *tempTicker = [[self.btceApiHandler getTicker] copy];
        mainQueueStart
        if (tempTicker != nil)
            self.ticker = tempTicker;
        mainQueueEnd
        tempTicker = nil;
        
            mainQueueStart
                isUpdateNeeded = YES;
            mainQueueEnd
        downloadQueueEnd
    }
}

@end
