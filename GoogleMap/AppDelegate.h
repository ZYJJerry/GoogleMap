//
//  AppDelegate.h
//  GoogleMap
//
//  Created by Jerry on 2017/6/2.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong)HomeViewController *mainVC;
@property (nonatomic,strong) UINavigationController *nav;
@end

