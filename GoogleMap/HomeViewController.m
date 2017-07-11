//
//  HomeViewController.m
//  Drawer
//
//  Created by Jerry on 16/9/14.
//  Copyright © 2016年 ZYJ. All rights reserved.
//

#import "HomeViewController.h"
#import "TabBarViewController.h"
#import "HelperDefine.h"
#import "UIView+Addition.h"
static HomeViewController * home = nil;
@interface HomeViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView * maskView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mid.view];
}

+ (id)shareSingleton{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!home) {
            home = [[HomeViewController alloc]init];
        }
    });
    return home;
}
- (void)createView {
    [self createMaskView];
}
- (void)createMaskView{
    self.maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reviseMidView)];
    [self.maskView addGestureRecognizer:gesture];
    UISwipeGestureRecognizer * swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(reviseMidView)];
    swip.direction = UISwipeGestureRecognizerDirectionLeft;
    self.maskView.backgroundColor = UIColorFromRGB(0xD6D6D6);
    self.maskView.alpha = 0.5;
    [self.maskView addGestureRecognizer:swip];
}

- (void)reviseMidView{
    
#if 0
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.maskView removeFromSuperview];
        self.mid.view.transform = CGAffineTransformMakeScale(1, 1);
        [self.mid.view setXOffset:0];
    } completion:^(BOOL finished) {
 
        [self.left.view removeFromSuperview];
    }];
    
#else
    
    [UIView animateWithDuration:0.3 animations:^{
         [self.maskView removeFromSuperview];
        self.mid.view.transform = CGAffineTransformMakeScale(1, 1);
        [self.left.view setXOffset:-ScreenWidth];
//        [self.left.view setWidth:ScreenWidth];
    } completion:^(BOOL finished) {
       
//        [self.left.view removeFromSuperview];
    }];
    
#endif
    
}

+ (void)showLeftViewController{
    [home showLeftViewController];
}

- (void)showLeftViewController{
    
#if 0
    
    [self createView];
    [self.view insertSubview:self.left.view belowSubview:self.mid.view];
    if (!self.maskView.superview) {
        [self.mid.view addSubview:self.maskView];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.mid.view.transform = CGAffineTransformScale(self.mid.view.transform, 1, 1);
        [self.mid.view setXOffset:ScreenWidth-100];
    }];
    
#else
    
    [self createView];
    self.left.view.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
    [self.view insertSubview:self.left.view aboveSubview:self.mid.view];
    if (!self.maskView.superview) {
        [self.mid.view addSubview:self.maskView];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.mid.view.transform = CGAffineTransformScale(self.mid.view.transform, 1, 1);
        [self.left.view setXOffset:-100];
//        [self.left.view setWidth:ScreenWidth-100];
    }];
    
#endif
    
}
/**
 *  是否响应多个手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
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
