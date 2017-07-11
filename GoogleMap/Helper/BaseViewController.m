//
//  BaseViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/5.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "BaseViewController.h"
#import "HelperDefine.h"
#import "AppDelegate.h"

@interface BaseViewController ()


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    self.view.backgroundColor = [UIColor whiteColor];
    //创建自定义的导航栏和item
    [self addNavigationbar];
}

- (void)indeterminateShow{
    self.intederHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}



- (void)addNavigationbar{
    // 创建一个导航栏
     self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    // 导航栏背景颜色
    self.navBar.barTintColor = [UIColor grayColor];
    
    // 自定义导航栏的title，用UILabel实现
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    self.titleLabel.text = @"自定义";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    
    // 创建导航栏组件
    self.navItem = [[UINavigationItem alloc] init];
    // 设置自定义的title
    self.navItem.titleView = self.titleLabel;
    
    // 创建左侧按钮
    self.leftButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    [self.leftButton setImage:[UIImage imageNamed:@"navigationBack"]];
    self.leftButton.tintColor = [UIColor whiteColor];
    
    // 创建右侧按钮
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"rightButton" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
//    rightButton.tintColor = [UIColor orangeColor];
    
    // 添加左侧、右侧按钮
    [self.navItem setLeftBarButtonItem:self.leftButton animated:false];
//    [navItem setRightBarButtonItem:rightButton animated:false];
    // 把导航栏组件加入导航栏
    [self.navBar pushNavigationItem:self.navItem animated:false];
    
    // 导航栏添加到view上
    [self.view addSubview:self.navBar];
}

//返回
- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
//    AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
//    delegate.nav.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
//    AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
//    delegate.nav.navigationBarHidden = NO;
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
