//
//  BtceApiHandler.m
//  BTCEBot
//
//  Created by Nikita Kolmogorov on 06.04.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "BtceApiHandler.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NKAchievementManager.h"

@implementation BtceApiHandler

#pragma mark -
#pragma mark Methods for dispatching
#pragma mark -

static dispatch_queue_t sharedDownloadQueue;
+ (dispatch_queue_t)sharedDownloadQueue {
    if (sharedDownloadQueue == nil);
        sharedDownloadQueue = dispatch_queue_create("download", NULL);
    return sharedDownloadQueue;
}

static dispatch_queue_t sharedTradeQueue;
+ (dispatch_queue_t)sharedTradeQueue {
    if (sharedTradeQueue == nil)
        sharedTradeQueue = dispatch_queue_create("trade", NULL);
    return sharedTradeQueue;
}

static dispatch_queue_t sharedGraphQueue;
+ (dispatch_queue_t)sharedGraphQueue {
    if (sharedGraphQueue == nil);
        sharedGraphQueue = dispatch_queue_create("graph", NULL);
    return sharedGraphQueue;
}

#pragma mark -
#pragma mark Top methods for working with server
#pragma mark -

/*!
 Method to sell a pair
 \param pair Pair which we want to sell
 \param rate Rate at which we want to sell
 \param amount Amount to sell
 \return YES if successful; NO otherwise
 */
- (BOOL)sellPair:(Pair)pair atRate:(NSString *)rate andAmount:(NSString *)amount {
    NSMutableDictionary *post = [[NSMutableDictionary alloc]
                                 initWithObjectsAndKeys:
                                 @"Trade", @"method",
                                 getStringForPair(pair), @"pair",
                                 @"sell", @"type",
                                 rate, @"rate",
                                 amount, @"amount",
                                 nil];
    
    NSData *data = [self getResponseFromServerForPost:post];
    
    [[NKAchievementManager sharedAchievementManager] sold:pair amount:[amount doubleValue]];

    return (data != nil);
}

/*!
 Method to buy a pair
 \param pair Pair which we want to buy
 \param rate Rate at which we want to buy
 \param amount Amount to buy
 \return YES if successful; NO otherwise
 */
- (BOOL)buyPair:(Pair)pair atRate:(NSString *)rate andAmount:(NSString *)amount {
    NSMutableDictionary *post = [[NSMutableDictionary alloc]
                                 initWithObjectsAndKeys:
                                 @"Trade", @"method",
                                 getStringForPair(pair), @"pair",
                                 @"buy", @"type",
                                 rate, @"rate",
                                 amount, @"amount",
                                 nil];
    
    NSData *data = [self getResponseFromServerForPost:post];
    
    [[NKAchievementManager sharedAchievementManager] bought:pair amount:[amount doubleValue]];
    
    return (data != nil);
}

/*!
 Method to get personal info from market
 \return NSDictionary in format @[openOrdersCount,transactionCount,apiRights,funds]; nil if error
 */
- (NSDictionary *)getInfo {
    NSData *data = [self getResponseFromServerForPost:@{@"method" : @"getInfo"}];
    
    if (data != nil) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        return @{@"openOrders" : json[@"return"][@"open_orders"],
                   @"transactionCount" : json[@"return"][@"transaction_count"],
                   @"apiRights" : @[json[@"return"][@"rights"][@"info"], json[@"return"][@"rights"][@"trade"], json[@"return"][@"rights"][@"withdraw"]],
                   @"funds" : json[@"return"][@"funds"]};
    }
    
    return nil;
}

/*!
 Method to get rates for a pair
 \param pair Pair for which we need to get rates
 \return Dictionary with required data (@"high", @"low", @"avg", etc.); nil if error
 */
- (NSDictionary *)getSellAndBuyRateForPair:(Pair)pair {
    NSData *data = [self getResponseFromPublicServerUrl:[NSString stringWithFormat:@"%@%@%@",@"https://btc-e.com/api/2/",getStringForPair(pair),@"/ticker"]];
    
    if (data != nil) {
        NSDictionary* json = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:kNilOptions
                                error:nil];
        return json[@"ticker"];
    }
    return nil;
}

/*!
 Method to get fee for a pair
 \param pair Pair for which we need to get fee
 \return String with fee (in percents: 0.2. etc.); nil if error
 */
- (NSString *)getFeeForPair:(Pair)pair {
    
    NSData *data = [self getResponseFromPublicServerUrl:[NSString stringWithFormat:@"%@%@%@",@"https://btc-e.com/api/2/",getStringForPair(pair),@"/fee"]];
    
    if (data != nil) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        return json[@"trade"];
    }
    return nil;
}

/*!
 Method to get orders for a pair
 \param pair Pair which orders we need to get
 \return Dictionary with required data (@"asks", @"bids" fields); nil if error
 */
- (NSDictionary *)getOrdersForPair:(Pair)pair {
    NSData *data = [self getResponseFromPublicServerUrl:[NSString stringWithFormat:@"%@%@%@",@"https://btc-e.com/api/2/",getStringForPair(pair),@"/depth/100"]];
    
    if (data != nil) {
        return [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:nil];
    }
    
    return nil;
}

/*!
 Method to get private open orders for a pair
 \param pair Pair which orders we need to get
 \return Dictionary with required data; nil if error
 */
- (NSDictionary *)getOpenOrdersForPair:(Pair)pair {
    NSData *data = [self getResponseFromServerForPost:@{@"method" : @"OrderList",
                                                        @"pair" : getStringForPair(pair),
                                                        @"active" : @"1"}];
    if (data != nil) {
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:nil];
        return [json objectForKey:@"return"];
    }
    
    return nil;
}

/*!
 Method to get trade history for a pair
 \param pair Pair which trade hostory we need to get
 \return Dictionary with required data; nil if error
 */
- (NSArray *)getTradeHistoryForPair:(Pair)pair {
    NSData *data = [self getResponseFromServerForPost:@{@"method" : @"TradeHistory",
                                                        @"pair" : getStringForPair(pair)}];
    if (data != nil) {
        NSDictionary *json = [[NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:nil] objectForKey:@"return"];
        
        // Need to sort and convert to Array
        NSMutableArray *jsonKeys = [[json allKeys] mutableCopy];
        NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
        [jsonKeys sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (NSNumber *tradeId in jsonKeys) {
            [result addObject:[json objectForKey:tradeId]];
        }
        
        return result;
    }
    return nil;
}

/*!
 Method to get trades for a pair
 \param pair Pair which trades we need to get
 \return Array with required data
 */
- (NSArray *)getTradesForPair:(Pair)pair {
    NSData *data = [self getResponseFromPublicServerUrl:[NSString stringWithFormat:@"%@%@%@",@"https://btc-e.com/api/2/",getStringForPair(pair),@"/trades/2000"]];
    
    if (data != nil) {
        return [NSJSONSerialization
                  JSONObjectWithData:data
                  options:kNilOptions
                  error:nil];
    }
    return nil;
}

/*!
 Method to get ticker for all pairs
 \return NSDictionary with tickers
 */
- (NSDictionary *)getTicker {
    NSData *data = [self getResponseFromPublicServerUrl:@"https://btc-e.com/api/3/ticker/btc_usd-btc_eur-btc_rur-ltc_btc-ltc_usd-ltc_rur-ltc_eur-nmc_btc-nmc_usd-nvc_btc-nvc_usd-usd_rur-eur_usd-trc_btc-ppc_btc-ftc_btc"];
    
    if (data != nil) {
        return [NSJSONSerialization
                  JSONObjectWithData:data
                  options:kNilOptions
                  error:nil];
    }
    
    return nil;
}

/*!
 Method to cancel order
 \param orderID Id of order that we want to cancel
 \return YES if successful, NO if error
 */
- (BOOL)cancelOrderWithId:(NSString *)orderID {
    NSDictionary *post = @{@"method" : @"CancelOrder",
                           @"order_id" : orderID};
    NSData *data = [self getResponseFromServerForPost:post];
    return (data != nil);
}

#pragma mark -
#pragma mark Deep methods for working with server
#pragma mark -

/*!
 Method to get data from private API
 \param postDictionary dictionary with all the required key-value pairs
 \param trade Boolean to use tradeQueue or not
 \return Data from server; nil if error
 */
- (NSData *)getResponseFromServerForPost:(NSDictionary *)postDictionary {
    // Do not do anything if there is no api key
    if (api_key == nil || [api_key isEqualToString:@""])
        return nil;
    
    // Make a post string
    NSMutableString *post = [@"" mutableCopy];
    for (int i = 0; i < [postDictionary allKeys].count; i++) {
        if (i == 0) {
            [post appendFormat:@"%@=%@", [postDictionary allKeys][i], postDictionary[[postDictionary allKeys][i]]];
        } else {
            [post appendFormat:@"&%@=%@", [postDictionary allKeys][i], postDictionary[[postDictionary allKeys][i]]];
        }
    }
    [post appendFormat:@"&nonce=%@", [self getNonce]];
    
    // Make signed post string
    const char *cKey = [api_secret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [post cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSMutableString *signedPost = [NSMutableString stringWithCapacity:sizeof(cHMAC) * 2];
    for (int i = 0; i < sizeof(cHMAC); i++) {
        [signedPost appendFormat:@"%02x", cHMAC[i]];
    }
    
    // Make a request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:
                                    [NSURL URLWithString:@"https://btc-e.com/tapi"]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:api_key forHTTPHeaderField:@"key"];
    [request setValue:signedPost forHTTPHeaderField:@"sign"];
    [request setHTTPBody:[post dataUsingEncoding: NSUTF8StringEncoding]];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Check data
    data = [self checkIfDataIsReturnedAndValid:data];
    
    return data;
}

/*!
 Method to get data from public url
 \param urlString url from where to get data
 \return Data from url; nil if error
 */
- (NSData *)getResponseFromPublicServerUrl:(NSString *)urlString {
    return [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
}

/*!
 Method for checking if data is valid. If possible, logs error to console
 \param data Data to check
 \return Given data if everything is right; nil if something wrong
 */
- (NSData *)checkIfDataIsReturnedAndValid:(NSData *)data {
    if (data != nil) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        if ([[[json objectForKey:@"success"] stringValue] isEqualToString:@"0"]) {
            NSLog(@"%@",json);
            data = nil;
            // Make a check for error here if needed
        }
    }
    return data;
}

static int nonceIncrement;
static int prevNonce;

/*!
 Method for getting nonce. Uses timestamp, can be 100 different nonces in one second
 \return String with nonce
 */
- (NSString *)getNonce {
    nonceIncrement = (nonceIncrement >= 90) ? 0 : nonceIncrement + 1;
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    int currentNonce = [NSNumber numberWithDouble: timeStamp].intValue;
    
    if (currentNonce != prevNonce) {
        nonceIncrement = 0;
        prevNonce = currentNonce;
    }
    
    currentNonce = (currentNonce * 100) + nonceIncrement;
    NSString *nonceString = [NSString stringWithFormat:@"%i",currentNonce];
    
    return nonceString;
}

#pragma mark -
#pragma mark Usefull functions
#pragma mark -

/*!
 Method to get pair string from Pair
 \param pair Pair enumeration
 \return String with pair name 
 \example Can return @"btc_usd", @"ltc_btc", etc.
 */
NSString *getStringForPair(Pair pair) {
    switch (pair) {
        case btc_usd:
            return @"btc_usd";
            break;
        case btc_eur:
            return @"btc_eur";
            break;
        case btc_rur:
            return @"btc_rur";
            break;
        case ltc_btc:
            return @"ltc_btc";
            break;
        case ltc_usd:
            return @"ltc_usd";
            break;
        case ltc_rur:
            return @"ltc_rur";
            break;
        case ltc_eur:
            return @"ltc_eur";
            break;
        case nmc_btc:
            return @"nmc_btc";
            break;
        case nmc_usd:
            return @"nmc_usd";
            break;
        case nvc_btc:
            return @"nvc_btc";
            break;
        case nvc_usd:
            return @"nvc_usd";
            break;
        case usd_rur:
            return @"usd_rur";
            break;
        case eur_usd:
            return @"eur_usd";
            break;
        case trc_btc:
            return @"trc_btc";
            break;
        case ppc_btc:
            return @"ppc_btc";
            break;
        case ftc_btc:
            return @"ftc_btc";
            break;
        default:
            return @"Error";
            break;
    }
}

/*!
 Method to get uppercase string from Pair
 \param pair Pair enumeration
 \return String with pair name
 \example Can return @"BTC/USD", @"LTC/BTC", etc.
 */
NSString *getUppercaseStringForPair(Pair pair) {
    NSString *text = [getStringForPair(pair) uppercaseString];
    text = [NSString stringWithFormat:@"%@/%@",[text substringToIndex:3], [text substringFromIndex:4]];
    return text;
}

/*!
 Function to sign data with key
 \param key Api secret
 \param data Data that needs to be signed
 \return String with hashed signed data
 */
NSString *hmacForKeyAndData(NSString *key, NSString *data) {
    const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSMutableString *hashString = [NSMutableString stringWithCapacity:sizeof(cHMAC) * 2];
    for (int i = 0; i < sizeof(cHMAC); i++) {
        [hashString appendFormat:@"%02x", cHMAC[i]];
    }
    return hashString;
}



@end
