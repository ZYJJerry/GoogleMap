//
//  BaseViewController.h
//  GoogleMap
//
//  Created by Jerry on 2017/6/5.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "InternetEngine.h"
#import "URL.h"
@interface BaseViewController : UIViewController
@property (nonatomic,strong)MBProgressHUD * hud;
@property (nonatomic,strong)MBProgressHUD *intederHud;
@property (nonatomic,strong)UINavigationBar * navBar;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UINavigationItem * navItem;
@property (nonatomic,strong)UIBarButtonItem * leftButton;
- (void)initStringHudWith:(NSString *)string;
- (void)indeterminateShow;
- (void)popViewController;
@end
