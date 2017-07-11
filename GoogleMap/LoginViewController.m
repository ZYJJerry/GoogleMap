//
//  LoginViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/7.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "NSString+Extension.h"
#import "InternetEngine.h"
#import "URL.h"
#import "MBProgressHUD.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextfield;
@property (nonatomic,strong)MBProgressHUD * hud;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.accountTextfield.layer.borderWidth
    [self.accountTextfield setValue:[UIColor whiteColor]forKeyPath:@"_placeholderLabel.textColor"];
    [self.pwdTextfield setValue:[UIColor whiteColor]forKeyPath:@"_placeholderLabel.textColor"];
    UIButton * account = [self.accountTextfield valueForKey:@"_clearButton"];
    [account setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    UIButton * pwd = [self.pwdTextfield valueForKey:@"_clearButton"];
    [pwd setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    self.accountTextfield.text = [user valueForKey:@"username"];
}

//hud
- (void)initStringHudWith:(NSString *)string{
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc]init];
    }
    [self.view addSubview:self.hud];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = NSLocalizedString(string, nil);
    self.hud.center = self.view.center;
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES afterDelay:1.5];
}

- (void)judge{

}


- (IBAction)loginButtonDidClicked:(id)sender {
    if (![self.accountTextfield.text isPhoneNumber]) {
        [self initStringHudWith:@"手机号不正确!"];
    }
    else if (![self.pwdTextfield.text isPassWord]){
        [self initStringHudWith:@"密码格式不正确!"];
    }else if ([self.accountTextfield.text isPhoneNumber] && [self.pwdTextfield.text isPassWord]) {
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user setValue:self.accountTextfield.text forKey:@"username"];
        NSMutableDictionary * para = [NSMutableDictionary new];
        [para setValue:self.accountTextfield.text forKey:@"username"];
        [para setValue:self.pwdTextfield.text forKey:@"pwd"];
        [InternetEngine postDataWithUrl:SERVER_IP(@"2012") parameters:para success:^(id result) {
            NSDictionary * dic = result;
            NSLog(@"%@",dic);
            if ([dic[@"result"] isEqualToNumber:@0]) {
                AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                self.view.window.rootViewController = delegate.nav;
            [user setValue:dic[@"uid"] forKey:@"userId"];
            [user setBool:YES forKey:@"isLogin"];
            }else{
                [self initStringHudWith:result[@"msg"]];
            }
        } fail:^(NSError * error) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.accountTextfield resignFirstResponder];
    [self.pwdTextfield resignFirstResponder];
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
