#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification      @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification    @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property(nonatomic, retain) SKProduct *proUpgradeProduct;
@property(nonatomic, retain) SKProductsRequest *productsRequest;

- (void)requestProductData;
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProduct;

@end