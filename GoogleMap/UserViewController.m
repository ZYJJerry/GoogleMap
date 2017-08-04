

//
//  UserViewController.m
//  FindBike1.1
//
//  Created by Jerry on 16/7/8.
//  Copyright © 2016年 zhouyuju. All rights reserved.
//

#import "UserViewController.h"
#import "HelperDefine.h"
#import "UserTableViewCell.h"
#import "BackImageView.h"
#import "Factory.h"
#import "LoginViewController.h"
#import "BDImagePicker.h"
#import "UIImage+ImageBlurEffect.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "URL.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SecurityUtil.h"
#import "InternetEngine.h"
#import "UIImage+AFNetworking.h"
#import "NickNameViewController.h"
#import "GenderViewController.h"
#import "PwdViewController.h"
@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,changUserGender>
@property (nonatomic,strong)UITableView * tableView;
/** 头像背景 */
@property (nonatomic,strong)BackImageView * backImageView;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    [self initTableView];
    self.navigationItem.leftBarButtonItem.tintColor = BlackColor;
    [self initBackView];
}

- (void)changeGender:(NSInteger)gender{
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
    UserTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexpath];
    cell.secondLabel.text = (gender == 1?NSLocalizedString(@"男",nil):NSLocalizedString(@"女",nil));
}

- (void)getNetData{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    [InternetEngine postDataWithUrl:SERVER_IP(@"2018") parameters:@{@"uid":[user valueForKey:@"userId"],@"nickname":@"",@"Sex":@""} success:^(id result) {
        
    } fail:^(NSError * error) {
        
    }];
}

//设置头像及其后的背景
- (void)initBackView{
    self.backImageView = [[BackImageView alloc]initWithFrame:CGRectMake(0, -ScreenWidth, ScreenWidth, ScreenWidth)];
    self.backImageView.iconImage.layer.cornerRadius = 50;
    self.backImageView.iconImage.layer.masksToBounds = YES;
    [self.backImageView.iconImage setBackgroundImage:self.headImage forState:UIControlStateNormal];
    [self.backImageView.iconImage addTarget:self action:@selector(changeMyPhoto) forControlEvents:UIControlEventTouchUpInside];
    self.backImageView.image = self.headImage;
    [self.tableView insertSubview:self.backImageView atIndex:0];
}
//初始化tableview
- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.contentInset = UIEdgeInsetsMake(ScreenWidth * 0.5, 0, 0, 0);
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"UserTableViewCell";
    
    if (indexPath.section == 0) {
        UserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserTableViewCell" owner:self options:nil]lastObject];
        }
        if (indexPath.row == 0) {
            cell.firstLabel.text =NSLocalizedString(@"姓名",nil);
            cell.secondLabel.text = self.dic[@"nickname"];
        }else if (indexPath.row == 1){
            cell.firstLabel.text = NSLocalizedString(@"性别",nil);
            cell.secondLabel.text = ([self.dic[@"sex"] isEqualToNumber:@1]? NSLocalizedString(@"男",nil):NSLocalizedString(@"女",nil));
        }else if(indexPath.row == 2){
            cell.firstLabel.text = NSLocalizedString(@"密码",nil);
            cell.secondLabel.text = @"";
        }else if(indexPath.row == 3){
            cell.firstLabel.text = NSLocalizedString(@"电话",nil);
            NSMutableString * str = [self.dic[@"mobile"] mutableCopy];
            [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            cell.secondLabel.text = str;
            cell.image.hidden = YES;
        }
        return cell;
    }else{
        //退出
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        label.text = NSLocalizedString(@"退出账号",nil);
        label.textColor = WhiteColor;
        label.backgroundColor = red;
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //退出账号
    if (indexPath.section == 1 && indexPath.row == 0) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"是否退出账号?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"退出",nil), nil];
        [alertview show];
    }
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            NickNameViewController * nvc = [[NickNameViewController alloc]init];
           nvc.nickName = self.dic[@"nickname"];
            [self.navigationController pushViewController:nvc animated:YES];
        }
        if (indexPath.row == 1) {
            GenderViewController * gvc = [[GenderViewController alloc]init];
            gvc.delegate = self;
             gvc.flag = [self.dic[@"sex"] integerValue];
            [self.navigationController pushViewController:gvc animated:YES];
        }
        if (indexPath.row == 2) {
            PwdViewController * pvc = [[PwdViewController alloc]init];
            [self.navigationController pushViewController:pvc animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user setValue:nil forKey:@"userId"];
        [user setBool:NO forKey:@"isLogin"];
        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LoginViewController * vc = [[LoginViewController alloc]init];
        delegate.window.rootViewController = vc;
        [self popViewController];
        HomeViewController * home = [HomeViewController shareSingleton];
        [home reviseMidView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 40;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //     向下拽了多少距离
    CGFloat down = -scrollView.contentOffset.y-(ScreenWidth * 0.5);
    NSLog(@"%f",down);
    if (down <=0 || down >=64 ) {
        return;
    }
//    CGRect frame = self.backImageView.frame;
    //改变图片的frame
//    frame.size.height = ScreenWidth + down;
    //改变头像的frame
    CGRect subFrame = self.backImageView.iconImage.frame;
    subFrame.size.width = 100 + down;
    subFrame.size.height = 100 + down;
    subFrame.origin.x = ScreenWidth/2-50 - down/2;
    subFrame.origin.y = ScreenWidth-140 - down/2;
    self.backImageView.iconImage.frame = subFrame;
    self.backImageView.iconImage.layer.cornerRadius = 50+down/2;
    [self.backImageView.iconImage layoutSubviews];
    self.backImageView.iconImage.layer.masksToBounds = YES;
//    self.backImageView.frame = frame;
}

//用户更换头像
- (void)changeMyPhoto{
    NSLog(@"更换头像");
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image) {
            [self indeterminateShow];
            UIImage *originOneImage = image;
            NSData *imgOneData = UIImageJPEGRepresentation(originOneImage, 1);
            NSString *encodedImageStrOne = [[NSString alloc] init];
            encodedImageStrOne = [SecurityUtil encodeBase64Data:imgOneData];
            encodedImageStrOne = [@"data:image/jpg;base64," stringByAppendingString:encodedImageStrOne];
            //  NSLog(@"%@",encodedImageStrOne);
            NSDictionary *dic = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"headImg":encodedImageStrOne};
            [InternetEngine postDataWithUrl:SERVER_IP(@"2019") parameters:dic success:^(id result) {
                [self.intederHud hideAnimated:YES];
                if(result){
                    NSDictionary * dic = result;
                    
                    if ([dic[@"result"] isEqualToNumber:@0]) {
                        self.backImageView.image = image;
                        [self.backImageView.iconImage setBackgroundImage:image forState:UIControlStateNormal];
                        [self.delegate changePhotoWithImage:image];
                    }else{
                    }
                }else{
                }
            } fail:^(NSError *error) {
                
            }];

        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end






