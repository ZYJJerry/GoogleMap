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
@interface WalletViewController ()
@property (weak, nonatomic) IBOutlet UICountingLabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *balanceButton;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet UIButton *depositButton;

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
