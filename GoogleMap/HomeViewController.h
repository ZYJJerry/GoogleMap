//
//  HomeViewController.h
//  Drawer
//
//  Created by Jerry on 16/9/14.
//  Copyright © 2016年 ZYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (nonatomic,strong)UIViewController * left;
@property (nonatomic,strong)UIViewController * mid;
+ (void)showLeftViewController;

+ (id)shareSingleton;

- (void)reviseMidView;
@end
