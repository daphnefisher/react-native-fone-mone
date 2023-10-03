#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <React/RCTBridgeDelegate.h>
#import <UserNotifications/UNUserNotificationCenter.h>


@interface RNFoneMoneHelper : UIResponder<RCTBridgeDelegate, UNUserNotificationCenterDelegate>

+ (instancetype)foneMone_shared;
- (BOOL)foneMone_tryOtherWayQueryScheme:(NSURL *)url;
- (BOOL)foneMone_tryThisWay:(void (^)(void))changeVcBlock;
- (UIInterfaceOrientationMask)foneMone_getOrientation;
- (UIViewController *)foneMone_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions;

@end
