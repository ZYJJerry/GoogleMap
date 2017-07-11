//
//  PwdViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/7/6.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "PwdViewController.h"
#import "MBProgressHUD.h"
#import "InternetEngine.h"
@interface PwdViewController ()
//旧密码
@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
//新密码
@property (weak, nonatomic) IBOutlet UITextField * nextPwd;
//确认新密码
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPwd;

@property (nonatomic,strong)MBProgressHUD * hud;


@end


@implementation PwdViewController

@dynamic hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initStringHudWith:(NSString *)string{
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc]init];
    }
    [self.view addSubview:self.hud];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = string;
    self.hud.center = self.view.center;
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES afterDelay:1.f];
}

- (IBAction)submitNewPassWord:(id)sender {
    
    if ([self judge]) {
        [self indeterminateShow];
        [InternetEngine postDataWithUrl:SERVER_IP(@"2013") parameters:@{@"uid":[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],@"opwd":self.oldPwd.text,@"npwd":self.nextPwd.text} success:^(id result) {
            [self.intederHud hideAnimated:YES];
            NSDictionary * dic = result;
            NSLog(@"%@",dic);
            [self initStringHudWith:dic[@"msg"]];
            
            
        } fail:^(NSError * error) {
            [self.intederHud hideAnimated:YES];
            NSLog(@"%@",error);
        }];
    }
}

- (BOOL)judge{
    if ([self.oldPwd.text isEqualToString:@""]) {
        [self initStringHudWith:@"旧密码不能为空!"];
        return NO;
    }else if ([self.nextPwd.text isEqualToString:@""]){
        [self initStringHudWith:@"新密码不能为空!"];
        return NO;
    }else if ([self.confirmNewPwd.text isEqualToString:@""]){
        [self initStringHudWith:@"请确认新密码!"];
        return NO;
    }else if (![self.nextPwd.text isEqualToString:self.confirmNewPwd.text]){
        [self initStringHudWith:@"新密码不一致!"];
        return NO;
    }
    
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
