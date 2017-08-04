//
//  RechargeViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/7/26.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "RechargeViewController.h"
#import <BTAPIClient.h>
#import <BraintreeDropIn.h>
#import <BraintreeCore.h>
@interface RechargeViewController ()<PayPalPaymentDelegate>
{
    NSString * tokenizationKey;
}
@property(nonatomic, strong) PayPalConfiguration *payPalConfig;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
NSString *clientToken = @"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI0MzkzZTQ4MTk4ODNmZjEwZjIxYmU2ZmU4M2Y2Y2E3ZGExYzNhOGQ3ZjdkZjI2ZDgwOWRiYWNjMGRmOTY4ZWIwfGNyZWF0ZWRfYXQ9MjAxNy0wOC0wNFQwNzo0OTozMi40NjAzMzU0OTYrMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0=";
    [self showDropIn:clientToken];
//    [self initConfiguration];
}

- (void)showDropIn:(NSString *)clientTokenOrTokenizationKey {
    BTDropInRequest *request = [[BTDropInRequest alloc] init];
    BTDropInController *dropIn = [[BTDropInController alloc] initWithAuthorization:clientTokenOrTokenizationKey request:request handler:^(BTDropInController * _Nonnull controller, BTDropInResult * _Nullable result, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"ERROR");
        } else if (result.cancelled) {
            NSLog(@"CANCELLED");
        } else {
            // Use the BTDropInResult properties to update your UI
            // result.paymentOptionType
            // result.paymentMethod
            // result.paymentIcon
            // result.paymentDescription
        }
    }];
    [self presentViewController:dropIn animated:YES completion:nil];
}

- (void)initBraintree{
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:tokenizationKey];
}

- (void)initConfiguration{
    //是否接受信用卡
    _payPalConfig.acceptCreditCards = NO;
    //商家名称
    _payPalConfig.merchantName = @"天津市云单车科技发展有限公司";
    //商家隐私协议网址和用户授权网址-说实话这个没用到
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    //设置地址选项-在支付页面可选择账户地址信息
    typedef NS_ENUM(NSInteger, PayPalShippingAddressOption) {
        //不展示地址信息
        PayPalShippingAddressOptionNone = 0,
        //这个没试过，自行查阅
        PayPalShippingAddressOptionProvided = 1,
        //paypal账号下的地址信息
        PayPalShippingAddressOptionPayPal = 2,
        //全选
        PayPalShippingAddressOptionBoth = 3,
    };
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
    //生成paypal控制器，并模态出来(push也行)
    //将之前生成的订单信息和paypal配置传进来，并设置订单VC为代理
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self];
    //模态展示
    [self.navigationController pushViewController:paymentViewController animated:YES];

}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController{
    NSLog(@"支付取消");
}

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment{
    NSLog(@"支付完成");
    [self dismissViewControllerAnimated:YES completion:^{
        
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
