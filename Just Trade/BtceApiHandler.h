//
//  BtceApiHandler.h
//  BTCEBot
//
//  Created by Nikita Kolmogorov on 06.04.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#define api_key [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsApiKey]
#define api_secret [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsApiSecret]

typedef enum {
    btc_usd = 0,
    btc_eur,
    btc_rur,
    
    ltc_btc,
    ltc_usd,
    ltc_rur,
    ltc_eur,
    
    nmc_btc,
    nmc_usd,
    
    nvc_btc,
    nvc_usd,
    
    usd_rur,
    eur_usd,
    
    trc_btc,
    ppc_btc,
    ftc_btc
} Pair;

#import <Foundation/Foundation.h>

@interface BtceApiHandler : NSObject

+ (dispatch_queue_t)sharedDownloadQueue;
+ (dispatch_queue_t)sharedTradeQueue;
+ (dispatch_queue_t)sharedGraphQueue;

- (BOOL)sellPair:(Pair)pair atRate:(NSString *)rate andAmount:(NSString *)amount;
- (BOOL)buyPair:(Pair)pair atRate:(NSString *)rate andAmount:(NSString *)amount;
- (BOOL)cancelOrderWithId:(NSString *)orderID;

- (NSDictionary *)getInfo;
- (NSDictionary *)getSellAndBuyRateForPair:(Pair)pair;
- (NSString *)getFeeForPair:(Pair)pair;
- (NSDictionary *)getOrdersForPair:(Pair)pair;
- (NSDictionary *)getOpenOrdersForPair:(Pair)pair;
- (NSArray *)getTradeHistoryForPair:(Pair)pair;
- (NSArray *)getTradesForPair:(Pair)pair;
- (NSDictionary *)getTicker;

NSString *getStringForPair(Pair pair);
NSString *getUppercaseStringForPair(Pair pair);

@end
