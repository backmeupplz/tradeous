//
//  NKPurchaseHandler.h
//  Just Trade
//
//  Created by Nikita Kolmogorov on 21.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define purchaseHandler [NKPurchaseHandler sharedPurchaseHandler]

@interface NKPurchaseHandler : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate>

+ (NKPurchaseHandler *)sharedPurchaseHandler;

- (void)purchaseProProduct;
- (void)restorePurchases;

@end

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end
