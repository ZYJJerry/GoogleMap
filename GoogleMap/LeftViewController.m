//
//  LeftViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/2.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "LeftUserTableViewCell.h"
#import "LeftTableViewCell.h"
#import "UserViewController.h"
#import "WalletViewController.h"
#import "JourneyViewController.h"
#import "NewsViewController.h"
#import "DirectViewController.h"
#import "HelperDefine.h"
#import "UIImageView+AFNetworking.h"
#import "InternetEngine.h"
@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource,changeUserPhoto>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong)NSDictionary * dataSource;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self getNetData];
}

- (void)getNetData{
    self.dataSource = [NSDictionary new];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [InternetEngine postDataWithUrl:SERVER_IP(@"2017") parameters:@{@"uid":[user valueForKey:@"userId"]} success:^(id result) {
        self.dataSource = result;
        NSLog(@"%@",self.dataSource);
        [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    } fail:^(NSError * error) {
        
    }];
}

- (void)initView{
    [self.myTableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"left"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"LeftUserTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"leftUser"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

#pragma mark changePhotoDelegate

- (void)changePhotoWithImage:(UIImage *)image{
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
    LeftUserTableViewCell * cell = [self.myTableView cellForRowAtIndexPath:index];
    cell.iconImageView.image = image;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * userString = @"left";
    static NSString * leftUser = @"leftUser";
    if (indexPath.row == 0) {
        LeftUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:leftUser];
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:self.dataSource[@"headImg"]]];
        cell.nickNameLabel.text = self.dataSource[@"nickname"];
        return cell;
    }else{
    LeftTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:userString];
        
        switch (indexPath.row) {
            case 1:
                cell.userImageView.image = [UIImage imageNamed:@"cebian_icon_01"];
                cell.titleLabel.text = @"Journey";
                break;
            case 2:
                cell.userImageView.image = [UIImage imageNamed:@"cebian_icon_02"];
                cell.titleLabel.text = @"Wallet";
                break;
            case 3:
                cell.userImageView.image = [UIImage imageNamed:@"cebian_icon_03"];
                cell.titleLabel.text = @"News";
                break;
            case 4:
                cell.userImageView.image = [UIImage imageNamed:@"cebian_icon_04"];
                cell.titleLabel.text = @"Direct";
                break;
                
            default:
                break;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
//            delegate.nav.navigationBarHidden = NO;
    if (indexPath.row == 0) {
        UserViewController * uvc = [[UserViewController alloc]init];
        uvc.dic = self.dataSource;
        uvc.delegate = self;
        LeftUserTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        uvc.headImage = cell.iconImageView.image;
        [delegate.nav pushViewController:uvc animated:YES];
    }
    if (indexPath.row == 1) {
        JourneyViewController * jvc = [[JourneyViewController alloc]init];
        [delegate.nav pushViewController:jvc animated:YES];
        
    }
    if (indexPath.row == 2) {
        WalletViewController * wvc = [[WalletViewController alloc]init];
        [delegate.nav pushViewController:wvc animated:YES];
        
    }
    if (indexPath.row == 3) {
        NewsViewController * nvc = [[NewsViewController alloc]init];
        [delegate.nav pushViewController:nvc animated:YES];
        
    }
    if (indexPath.row == 4) {
        DirectViewController * dvc = [[DirectViewController alloc]init];
        [delegate.nav pushViewController:dvc animated:YES];
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100.f;
    }
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)viewWillAppear:(BOOL)animated{
//    UIView*statusBar = [[[UIApplication sharedApplication]valueForKey:@"statusBarWindow"]valueForKey:@"statusBar"];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        statusBar.frame = CGRectMake(0, -20, CGRectGetWidth(statusBar.frame), CGRectGetHeight(statusBar.frame));
//    }];
    NSLog(@"-------leftappera");

}

- (void)viewWillDisappear:(BOOL)animated{
//    UIView*statusBar = [[[UIApplication sharedApplication]valueForKey:@"statusBarWindow"]valueForKey:@"statusBar"];
//    [UIView animateWithDuration:0.3 animations:^{
//        statusBar.frame = CGRectMake(0, 0, CGRectGetWidth(statusBar.frame), CGRectGetHeight(statusBar.frame));
//    }];
    NSLog(@"======leftdisappera");
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
