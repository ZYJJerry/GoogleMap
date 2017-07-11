//
//  TabBarViewController.m
//  Drawer
//
//  Created by Jerry on 16/9/14.
//  Copyright © 2016年 ZYJ. All rights reserved.
//

#import "TabBarViewController.h"
#import "MapViewController.h"
#import "HelperDefine.h"
#import "Factory.h"
#import "TLMenuButton.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    [self setupAllChildViewControllers];
}

- (void)setupAllChildViewControllers
{
    // 地图页
    MapViewController *home = [[MapViewController alloc] init];
    home.tabBarItem.badgeValue = nil;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:home];
    [self addChildViewController:nav];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
