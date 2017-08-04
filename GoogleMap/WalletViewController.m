//
//  WalletViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/7.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "WalletViewController.h"
#import "UICountingLabel.h"
#import "InternetEngine.h"
#import "RechargeViewController.h"
#import <PayPalMobile.h>
@interface WalletViewController ()<PayPalPaymentDelegate>
@property (weak, nonatomic) IBOutlet UICountingLabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *balanceButton;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet UIButton *depositButton;
@property(nonatomic, strong) PayPalConfiguration *payPalConfig;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Wallet";

}

- (void)getMyMoney{
    [self indeterminateShow];
    [InternetEngine postDataWithUrl:SERVER_IP(@"2025") parameters:@{@"uid":[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]} success:^(id result) {
        [self.intederHud hideAnimated:YES];
        NSDictionary * dic = result;
        NSLog(@"%@",dic);
        self.depositLabel.text = dic[@"depamt"];
        [self showDataWithBalance:dic[@"amt"]];
    } fail:^(NSError * error) {
        [self.intederHud hideAnimated:YES];
    }];
}


- (void)showDataWithBalance:(NSString *)balance{

    if ([balance floatValue] == 0) {
        self.balanceLabel.text = balance;
    }else{
        self.balanceLabel.method = UILabelCountingMethodEaseInOut;
        self.balanceLabel.format = @"%.2f";
        //    __weak JourneyDetailViewController* blockSelf = self;
        //    self.bikeNoLabel.completionBlock = ^{
        //        blockSelf.bikeNoLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        //    };
        [self.balanceLabel countFrom:0 to:[balance floatValue]];
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self getMyMoney];
}
- (IBAction)recharge:(id)sender {
//    [self initConfiguration];
    RechargeViewController * rvc = [[RechargeViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)initConfiguration{
    //是否接受信用卡
    _payPalConfig.acceptCreditCards = YES;
    //商家名称
    _payPalConfig.merchantName = @"天津市云单车科技发展有限公司";
    //商家隐私协议网址和用户授权网址-说实话这个没用到
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    //paypal账号下的地址信息
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    //配置语言环境
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    //订单总额
    payment.amount = [NSDecimalNumber decimalNumberWithString:@"1"];
    //货币类型-RMB是没用的
    payment.currencyCode = @"USD";
    //订单描述
    payment.shortDescription = @"账户充值";
    //生成的订单号
    payment.custom = @"1234567890";
    //生成paypal控制器，并模态出来(push也行)
    //将之前生成的订单信息和paypal配置传进来，并设置订单VC为代理
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self];
    //模态展示
    [self presentViewController:paymentViewController animated:YES completion:^{
        
    }];
    
}
- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController{
    NSLog(@"点击取消按钮");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment{
    NSLog(@"支付完成");
    [self dismissViewControllerAnimated:YES completion:^{
        [self initStringHudWith:@"支付成功"];
    }];
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
