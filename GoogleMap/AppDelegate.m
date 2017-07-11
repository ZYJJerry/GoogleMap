//
//  AppDelegate.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/2.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "MapViewController.h"
#import "HomeViewController.h"
#import "TabBarViewController.h"
#import "LoginViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:@"AIzaSyCxGwfmxi8ELzMAqOzQpFzIzrfIGfMzzE4"];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.mainVC = [HomeViewController shareSingleton];
    LeftViewController * left = [[LeftViewController alloc]init];
    TabBarViewController * cvc = [[TabBarViewController alloc]init];
    self.mainVC.left = left;
    self.mainVC.mid = cvc;
    self.nav = [[UINavigationController alloc]initWithRootViewController:self.mainVC];
    self.nav.navigationBarHidden = YES;
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (isLogin) {
        self.window.rootViewController = self.nav;
        
    }else{
        LoginViewController * vc = [[LoginViewController alloc]init];
        self.window.rootViewController = vc;
    }
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
