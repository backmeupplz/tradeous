//////////
// Multithreading
//////////

#define downloadQueueStart dispatch_async([BtceApiHandler sharedDownloadQueue], ^{
#define downloadQueueEnd });

#define tradeQueueStart dispatch_async([BtceApiHandler sharedTradeQueue], ^{
#define tradeQueueEnd });

#define graphQueueStart dispatch_async([BtceApiHandler sharedGraphQueue], ^{
#define graphQueueEnd });

#define mainQueueStart dispatch_async(dispatch_get_main_queue(), ^{
#define mainQueueEnd });

//////////
// Device definitions
//////////

#define isIphone35 [[UIScreen mainScreen] bounds].size.height == 480

//////////
// Constants
//////////

#define kUserDefaultsApiKey @"api_key"
#define kUserDefaultsApiSecret @"api_secret"
#define kUserDefaultsAchievements @"achievements"

#define kInAppPurchasesTurnOffAddsIdentifier @"turnOffAdds"

//////////
// In-app purchases and ads
//////////

#define kUserDefaultsProPurchasedKey @"is_pro_purchased"
#define isPurchased YES//[[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsProPurchasedKey] boolValue]