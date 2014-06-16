//
//  DataFromServer.h
//  BTCEBot
//
//  Created by Nikita Kolmogorov on 14.06.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BtceApiHandler.h"

#define dataFromServerManager [DataFromServerManager sharedDataFromServerManager]

@interface DataFromServerManager : NSObject

// Properties to set manually
@property Pair pair;
@property (nonatomic, strong) BtceApiHandler *btceApiHandler;

// Properties got from server
@property (nonatomic, weak) NSString *openOrdersCount;
@property (nonatomic, weak) NSString *transactionsCount;
@property (nonatomic, weak) NSArray *apiRights;
@property (nonatomic, weak) NSDictionary *balance;
@property (nonatomic, weak) NSDictionary *btcUsdRate;
@property (nonatomic, weak) NSDictionary *btcUsdOrders;
@property (nonatomic, weak) NSArray *btcUsdTrades;
@property (nonatomic, weak) NSArray *chatData;

// Api v3
@property (nonatomic, weak) NSDictionary *ticker;

+ (DataFromServerManager *)sharedDataFromServerManager;

@end
