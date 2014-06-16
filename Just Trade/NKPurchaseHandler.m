//
//  NKPurchaseHandler.m
//  Just Trade
//
//  Created by Nikita Kolmogorov on 21.09.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import "NKPurchaseHandler.h"
#import "Reachability.h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@implementation NKPurchaseHandler {
    SKProduct *proProduct;
    SKProductsRequest *productsRequest;
}

#pragma mark -
#pragma mark Singleton pattern
#pragma mark -

+ (NKPurchaseHandler *)sharedPurchaseHandler {
    static NKPurchaseHandler *sharedPurchaseHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPurchaseHandler = [[self alloc] init];
    });
    return sharedPurchaseHandler;
}

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (id)init {
    self = [super init];
    if (self) {
        [self loadStore];
    }
    return self;
}

- (void)loadStore {
    // Get the product description
    [self requestProductData];
    
    // Restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)requestProductData {
    NSSet *productIdentifiers = [NSSet setWithObjects:kInAppPurchasesTurnOffAddsIdentifier,
                                 nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

    
#pragma mark -
#pragma mark SKProductsRequestDelegate
#pragma mark -

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    proProduct = [response.products lastObject];
    
    //NSLog(@"%@",proProduct.localizedTitle);
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}
    
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@",error.description);
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver
#pragma mark -

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"purchased: %@",transaction.payment.productIdentifier);
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kUserDefaultsProPurchasedKey];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"failed: %@",transaction.payment.productIdentifier);
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"restored: %@",transaction.payment.productIdentifier);
                break;
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark General methods
#pragma mark -

- (void)purchaseProProduct{
    
    if ([SKPaymentQueue canMakePayments])
        NSLog(@"Good");
    else
        NSLog(@"not good :(");
    
    if (proProduct != nil) {
        SKPayment *payment = [SKPayment paymentWithProduct:proProduct];
        
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Что-то пошло не так!",nil)
                                                        message:NSLocalizedString(@"Пожалуйста, перезапустите приложение и повторите попытку",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Хорошо!",nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)restorePurchases {
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end

@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    return formattedString;
}

@end
