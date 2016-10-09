//
//  AppDelegate.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "AppDelegate.h"
#import "PGNavigationController.h"
#import "PGHomeController.h"
#import "PGApp.h"
#import "PGPayManager.h"
#import "PGPatchManager.h"
#import "PGVersionManager.h"
#import "Reachability.h"
#import "PGCacheManager.h"

@interface AppDelegate ()
@property(nonatomic, strong)Reachability *hostReach;
@end

@implementation AppDelegate

- (void)showMainView:(UIWindow *)window
{
    PGHomeController *home = [[PGHomeController alloc] init];
    PGNavigationController *homeNav = [[PGNavigationController alloc] initWithRootViewController:home];
    homeNav.tempRootController = home;
    window.rootViewController = homeNav;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //清除缓存
    [PGCacheManager clearCacheDataForNewVersion];
    
    //热更新
    [[PGPatchManager shareInstance] startListen];
    [[PGPatchManager shareInstance] executeLocalHot];
    [[PGPatchManager shareInstance] getHotData];
    
    [[PGPayManager shareInstance] platformInit];
    
    [self showMainView:self.window];
    [PGApp configAppNavBar];
    
    [self.window makeKeyAndVisible];
    
    [self networkCheck];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     检测版本更新 
     */
    [PGVersionManager checkVersion];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 网络检测
- (void)networkCheck
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.hostReach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable)
    {
        [self.window.rootViewController showTitle:@"提示" msg:@"无网络连接"];
    }
}

@end
