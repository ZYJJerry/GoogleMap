//
//  ViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/2.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "MapViewController.h"
#import "LeftViewController.h"
#import "HomeViewController.h"
#import "HelperDefine.h"
#import "AFNetworking.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "URL.h"
#import "InternetEngine.h"
#import "MBProgressHUD.h"
@interface MapViewController ()<UITextFieldDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    __weak IBOutlet GMSMapView * MapView;
    //选中的marker
    GMSMarker * selectMarker;
    //设置一个是预约还是用车的标志位 0 默认值 1 预约 2 用车
    NSInteger flag;
    //操作的车号
    NSString * bikeID;
    //上一次锚点位置
    CLLocation * lastPosition;
    //显示锚点周围车辆范围
    int range;
    //是否预约了车
    BOOL isAppoint;
    //是否租用了车
    BOOL isRent;
    //车辆数组
    NSArray * bikeArray;
    //
}
@property (nonatomic,strong)CLLocationManager * locationManager;
//锚点
@property (nonatomic,strong)UIImageView * imageView;
//@property (weak, nonatomic) IBOutlet GMSMapView *myPosition;
@property (weak, nonatomic) IBOutlet UIView *alertView;
//遮罩
@property (nonatomic,strong)UIView * cover;
//车号
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
//弹出框提示信息
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
//预约/用车
@property (weak, nonatomic) IBOutlet UIButton *actionButton;


//确认预约/用车弹出框
@property (weak, nonatomic) IBOutlet UIView *nextAlertView;
//确认预约/用车信息
@property (weak, nonatomic) IBOutlet UILabel *nextAlertInfo;


//预约/用车的底部view
@property (weak, nonatomic) IBOutlet UIView *actionView;


//预约/用车的信息界面
@property (weak, nonatomic) IBOutlet UIView *appointOrRentView;
@property (weak, nonatomic) IBOutlet UILabel *bikeNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//取消预约按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelActionButton;
//解锁按钮
@property (weak, nonatomic) IBOutlet UIButton *unLockButton;
//响铃按钮
@property (weak, nonatomic) IBOutlet UIButton *ringButton;

@property (nonatomic,strong)NSTimer * Timer;
@property (nonatomic, assign) NSTimeInterval  timeInterval;

@property (nonatomic, assign) NSTimer * Timer_useCar;

//订单的id
@property (nonatomic,copy)NSString * oid;

//@property (nonatomic,copy)NSString * bikeNumber;

@property (nonatomic,strong)MBProgressHUD * hud;

@property (nonatomic,strong)MBProgressHUD * indeterHud;

@property (nonatomic,assign)NSUserDefaults * user;
//用车编号
@property (weak, nonatomic) IBOutlet UILabel *useCarNoLabel;
//用车时间
@property (weak, nonatomic) IBOutlet UILabel *useCarTimeLabel;
//用车页面详情
@property (weak, nonatomic) IBOutlet UIView *useCarView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [NSUserDefaults standardUserDefaults];
    self.title = @"Cloud Bike";
    [self createView];
    [self createPointView];
}

#pragma mark hud
- (void)indeterminateShow{
    self.indeterHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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

#pragma mark appoint
//预约
- (IBAction)appointBike:(id)sender {
    flag = 1;
    self.numberTextField.text = @"";
    if (!selectMarker) {
        [self addCover];
        [self.view bringSubviewToFront:self.alertView];
        self.infoLabel.text = NSLocalizedString(@"您也可以在地图中先选中要预约的车辆进行预约",nil);
        [self.actionButton setTitle:NSLocalizedString(@"现在预约",nil) forState:UIControlStateNormal];
        self.alertView.hidden = NO;
    }else{
        [self indeterminateShow];
        [InternetEngine postDataWithUrl:SERVER_IP(@"2004") parameters:@{@"id":selectMarker.title,@"lat":[NSString stringWithFormat:@"%f",MapView.myLocation.coordinate.latitude],@"lng":[NSString stringWithFormat:@"%f",MapView.myLocation.coordinate.longitude],@"uid":[self.user valueForKey:@"userId"],@"range":[NSString stringWithFormat:@"%d",range]} success:^(id result) {
            [self.indeterHud hideAnimated:YES];
            NSDictionary * dic = result;
            if ([dic[@"result"] isEqualToNumber:@0]) {
                
                self.nextAlertInfo.text = dic[@"msg"];
                //预约的车辆ID
                bikeID = dic[@"id"];
                [self addCover];
                [self.view bringSubviewToFront:self.nextAlertView];
                self.nextAlertView.hidden = NO;
                
            }else{
                [self initStringHudWith:dic[@"msg"]];
            }
            NSLog(@"%@",dic);
            NSLog(@"%@",dic[@"msg"]);
        } fail:^(NSError * error) {
            [self.indeterHud hideAnimated:YES];
            [self initStringHudWith:@"请求失败"];
        }];
    }
}


//取消预约/用车
- (IBAction)apponitCancel:(id)sender {
    [self.cover removeFromSuperview];
    self.nextAlertView.hidden = YES;
}
//确定预约/用车
- (IBAction)appointConfirm:(id)sender {
    [self.cover removeFromSuperview];
    self.nextAlertView.hidden = YES;
    if (flag == 1) {
        //确定预约
        [self indeterminateShow];
        [InternetEngine postDataWithUrl:SERVER_IP(@"2005") parameters:@{@"id":bikeID,@"uid":[self.user valueForKey:@"userId"]} success:^(id result) {
            [self.indeterHud hideAnimated:YES];
            NSDictionary * dic = result;
            if ([dic[@"result"] isEqualToNumber:@0]) {
                [self chargeIsUsingBike];

            }
            
        } fail:^(NSError * error) {
            [self.indeterHud hideAnimated:YES];
            [self initStringHudWith:@"请求失败"];
        }];
    }
    if (flag == 2) {
        //确定用车
        NSLog(@"确定用车");
        [self unlockBike];
    }
}
//用车
- (void)unlockBike{
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    [para setValue:bikeID forKey:@"id"];
    [para setValue:[self.user valueForKey:@"userId"] forKey:@"uid"];
    [para setValue:[NSString stringWithFormat:@"%f",MapView.myLocation.coordinate.longitude] forKey:@"lng"];
    [para setValue:[NSString stringWithFormat:@"%f",MapView.myLocation.coordinate.latitude] forKey:@"lat"];
    [self indeterminateShow];
    [InternetEngine postDataWithUrl:SERVER_IP(@"2008") parameters:para success:^(id result) {
        [self.indeterHud hideAnimated:YES];
        NSDictionary * dic = result;
        if ([dic[@"result"] isEqualToNumber:@0]) {
            [self chargeIsUsingBike];
        }
    } fail:^(NSError * error) {
        
    }];
}

#pragma mark rent

//用车
- (IBAction)useBike:(id)sender {
    flag = 2;
    self.numberTextField.text = @"";
    if (!selectMarker) {
        [self addCover];
        [self.view bringSubviewToFront:self.alertView];
        self.infoLabel.text = NSLocalizedString(@"您也可以在地图中先选中要解锁的车辆进行解锁",nil);
        [self.actionButton setTitle:NSLocalizedString(@"现在用车",nil) forState:UIControlStateNormal];
        self.alertView.hidden = NO;
    }else{
        [self addCover];
        [self.view bringSubviewToFront:self.nextAlertView];
        self.nextAlertInfo.text = NSLocalizedString(@"确定对该车解锁?",nil);
        bikeID = selectMarker.title;
        self.nextAlertView.hidden = NO;
    }
}

//取消
- (IBAction)cancelAppointBike:(id)sender {
    [self.numberTextField resignFirstResponder];
    self.alertView.hidden = YES;
    
    [self.cover removeFromSuperview];
}
//现在预约或者用车
- (IBAction)appointOrUseBike:(id)sender {
    
    if ([self.numberTextField.text isEqualToString:@""]) {
        [self initStringHudWith:NSLocalizedString(@"车号不能为空!",nil)];

        return;
    }
    [self.numberTextField resignFirstResponder];
    if (self.cover){
        [self.cover removeFromSuperview];
    }
    self.alertView.hidden = YES;
    if (flag == 1) {
        NSLog(@"预约");
        [self indeterminateShow];
        [InternetEngine postDataWithUrl:SERVER_IP(@"2004") parameters:@{@"id":self.numberTextField.text,@"lat":[NSString stringWithFormat:@"%f",MapView.myLocation.coordinate.latitude],@"lng":[NSString stringWithFormat:@"%f",MapView.myLocation.coordinate.longitude],@"uid":[self.user valueForKey:@"userId"],@"range":[NSString stringWithFormat:@"%d",range]} success:^(id result) {
            [self.indeterHud hideAnimated:YES];
            NSDictionary * dic = result;
            if ([dic[@"result"] isEqualToNumber:@0]) {
               
                self.nextAlertInfo.text = dic[@"msg"];
                //预约的车辆ID
                bikeID = dic[@"id"];
                [self.view bringSubviewToFront:self.nextAlertView];
                 self.nextAlertView.hidden = NO;
                
            }else{
                [self initStringHudWith:dic[@"msg"]];
            }
            NSLog(@"%@",dic);
            NSLog(@"%@",dic[@"msg"]);
        } fail:^(NSError * error) {
            [self.indeterHud hideAnimated:YES];
            [self initStringHudWith:@"请求失败"];
        }];
    }
    if (flag == 2){
        NSLog(@"用车");
        [self.view bringSubviewToFront:self.nextAlertView];
        self.nextAlertInfo.text = @"确定对该车解锁?计费方式为0.5元/分钟";
        bikeID = self.numberTextField.text;
        self.nextAlertView.hidden = NO;
    }
    
}

//添加遮罩层
- (void)addCover{
    self.cover = [[UIView alloc]initWithFrame:self.view.bounds];
    self.cover.alpha = 0.5;
    self.cover.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.cover];
}
//锚点
- (void)createPointView{
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"anchor"]];
    self.imageView.frame = CGRectMake(ScreenWidth/2.f,ScreenHeight/2.f, 0,0);
    self.imageView.contentMode = UIViewContentModeBottom;
    [self.view addSubview:self.imageView];
}
//回到我的位置
- (IBAction)backToMyPosition:(id)sender {
    if (MapView.myLocation.coordinate.longitude != 0 && MapView.myLocation.coordinate.latitude != 0) {
        MapView.camera=[GMSCameraPosition cameraWithLatitude:MapView.myLocation.coordinate.latitude longitude:MapView.myLocation.coordinate.longitude zoom:14];
    }
}

#pragma mark leftitem

- (void)createView{
    [self createLeftNavigationBarButtonWithTitle:nil image:@"leftItem_normal" target:self action:@selector(showLeftController)];
    self.alertView.hidden = YES;
    self.nextAlertView.hidden = YES;
}

//声明一个创建上导航的左侧按钮
- (void)createLeftNavigationBarButtonWithTitle:(NSString *)title image:(NSString *) image target:(id)target action:(SEL)selector {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:target action:selector];
    [left setImage:[UIImage imageNamed:image]];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}
//侧滑栏
- (void)showLeftController{
    [self.numberTextField resignFirstResponder];
    [HomeViewController showLeftViewController];
}

#pragma mark Mapview

- (void)initGMSMap{
    MapView.delegate = self;
    MapView.myLocationEnabled = YES;
    MapView.settings.rotateGestures = NO;
    //异步加载大头针
 
}

#pragma mark Location
- (void)location{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=50.0;//五十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}
//选中marker
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    selectMarker = marker;
    NSLog(@"%@",marker.title);
    NSLog(@"marker:%f==%f",marker.position.latitude,marker.position.longitude);
    return NO;
}

#pragma mark mapDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    selectMarker = nil;
    NSLog(@"tap");
}


- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
//    NSLog(@"1");
}
- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
//    NSLog(@"2");
}
//拖动锚点

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    CLLocation * new = [[CLLocation alloc]initWithLatitude:position.target.latitude longitude:position.target.longitude];
    CLLocationDistance distance = [new distanceFromLocation:lastPosition];
    lastPosition = new;
    //根据两次锚点之间的距离决定是否刷新锚点周围车辆,当锚点移动距离过小时可以不刷新
    NSLog(@"两点之间的距离:%f",distance);
    if (selectMarker == nil && flag != 1 && flag != 2) {
        //清除地图上的marker
        [mapView clear];
    NSMutableDictionary * para = [NSMutableDictionary new];
    [para setValue:[NSString stringWithFormat:@"%f",position.target.latitude] forKey:@"lat"];
    [para setValue:[NSString stringWithFormat:@"%f",position.target.longitude] forKey:@"lng"];
    [para setValue:[NSString stringWithFormat:@"%d",range] forKey:@"range"];
    [para setValue:[self.user valueForKey:@"userId"] forKey:@"uid"];
    NSLog(@"%@",para);
        [InternetEngine postDataWithUrl:SERVER_IP(@"2001") parameters:para success:^(id result) {
            NSLog(@"车辆:%@",result);
            NSArray * array = result[@"data"];
            [self addAnnotionWith:array];

        } fail:^(NSError * error) {
            [self.indeterHud hideAnimated:YES];
            [self initStringHudWith:@"请求失败"];
        }];
    }
    //移动锚点之后锚点的经纬度
    NSLog(@"锚点:%f--%f",position.target.latitude,position.target.longitude);
}

#pragma mark 预约界面的action

//取消预约
- (IBAction)cancelAppointAction:(id)sender {
    
    if (isAppoint) {
        [self cancelAppointWithOid:self.oid];
        NSLog(@"3");
    }
    
}

//解锁车辆
- (IBAction)unlockAction:(id)sender {
    [self unlockBike];
    
}

- (IBAction)useRingRing:(id)sender {
    [InternetEngine postDataWithUrl:SERVER_IP(@"2007") parameters:@{@"oid":self.oid} success:^(id result) {
        if(result){
            NSDictionary * dic = result;
            
            if ([dic[@"result"] isEqualToNumber:@0]) {
                //                NSLog(@"响了");
                CAKeyframeAnimation * keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
                keyAnimation.duration = 0.1;
                //设置抖动幅度
                //角度转换为弧度  度数/180*M_PI
                keyAnimation.values = @[@(-8/180.0*M_PI), @(8/180.0*M_PI), @(-8/180.0*M_PI)];
                //设置重复次数
                keyAnimation.repeatCount = 20;
                [self.ringButton.layer addAnimation:keyAnimation forKey:@"003"];
            }else{
                
            }
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
}

//响铃
- (IBAction)ringRingAction:(id)sender {
    
    [InternetEngine postDataWithUrl:SERVER_IP(@"2007") parameters:@{@"oid":self.oid} success:^(id result) {
        if(result){
            NSDictionary * dic = result;
            
            if ([dic[@"result"] isEqualToNumber:@0]) {
                //                NSLog(@"响了");
                CAKeyframeAnimation * keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
                keyAnimation.duration = 0.1;
                //设置抖动幅度
                //角度转换为弧度  度数/180*M_PI
                keyAnimation.values = @[@(-8/180.0*M_PI), @(8/180.0*M_PI), @(-8/180.0*M_PI)];
                //设置重复次数
                keyAnimation.repeatCount = 20;
                [self.ringButton.layer addAnimation:keyAnimation forKey:@"003"];
            }else{
                
            }
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
}




- (void)viewWillAppear:(BOOL)animated{
    range = 300;
    self.appointOrRentView.hidden = YES;
    self.useCarView.hidden = YES;
//    [self.hud showAnimated:YES];
    [self chargeIsUsingBike];
    [self initGMSMap];
    [self location];
    [self test];
}

- (void)test{
    NSLog(@"--------------------------------app界面开始展示");

}

#pragma mark 查看是否有订单

- (void)chargeIsUsingBike{
    NSLog(@"查看订单");
    [self indeterminateShow];
    [InternetEngine postDataWithUrl:SERVER_IP(@"2044") parameters:@{@"uid":[self.user valueForKey:@"userId"]} success:^(id result) {
        [self .indeterHud hideAnimated:YES];
        NSDictionary * dic = result;
        NSLog(@"确认是否有操作的车辆:%@",dic);
        if ([dic[@"result"] isEqualToNumber:@0]) {
        if ([dic[@"type"] isEqualToNumber:@1]) {
            flag = 1;
            self.appointOrRentView.hidden = NO;
            self.oid = dic[@"oid"];
//            self.bikeNumber = dic[@"no"];
            bikeID = dic[@"no"];
            isAppoint = YES;
            self.alertView.hidden = YES;
            self.nextAlertView.hidden = YES;
            self.cover.hidden = YES;
            [MapView clear];
            [self addAnnotionWith:@[@{@"lat":dic[@"lat"],@"lng":dic[@"lng"],@"no":dic[@"no"]}]];
            self.bikeNoLabel.text = [NSString stringWithFormat:@"  预约车辆:%@",dic[@"no"]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date1 = [dateFormatter dateFromString:dic[@"stDate"]];
            NSDate * date = [NSDate dateWithTimeInterval:[dic[@"offMinutes"] integerValue]*60 sinceDate:date1];
            long time = (long)[date timeIntervalSince1970]-(long)[[NSDate date] timeIntervalSince1970];
            if(time<=0){
                self.timeLabel.text = @"  剩余时间:0小时0分钟";
                [self cancelAppointWithOid:self.oid];
                return ;
            }else{
                self.timeInterval = time;
                NSInteger hou = (NSInteger)_timeInterval/3600;
                //  NSInteger day = timeout/3600/24;
                NSInteger minutes = ((NSInteger)_timeInterval%3600) / 60;
                NSInteger seconds = ((NSInteger)_timeInterval%3600) % 60;
                if (seconds>0) {
                    minutes+=1;
                }
                NSString *strTime = [NSString stringWithFormat:@"  剩余时间:%ld小时%ld分钟",(long)hou,(long)minutes];
                //设置界面的按钮显示 根据自己需求设置
                self.timeLabel.text = strTime;
                if ([self.Timer isValid]) {
                    [self.Timer invalidate];
                    _Timer = nil;
                }
                [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                self.Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeLabelShow) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.Timer forMode:NSRunLoopCommonModes];
            }
        }else if([dic[@"type"] isEqualToNumber:@2]){
            NSLog(@"%@",dic);
            flag = 2;
            bikeID = dic[@"no"];
            self.alertView.hidden = YES;
            self.nextAlertView.hidden = YES;
            self.cover.hidden = YES;
            [MapView clear];
            [self addAnnotionWith:@[@{@"lat":dic[@"lat"],@"lng":dic[@"lng"],@"no":dic[@"no"]}]];
            self.useCarView.hidden = NO;
            self.useCarNoLabel.text = [NSString stringWithFormat:@"  使用车辆:%@",dic[@"no"]];
            self.oid = [NSString stringWithFormat:@"%@",dic[@"oid"]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date1 = [dateFormatter dateFromString:dic[@"stDate"]];
            long time = (long)[[NSDate date] timeIntervalSince1970]-(long)[date1 timeIntervalSince1970];
            
            self.timeInterval = time;
            NSInteger hou = (NSInteger)_timeInterval/3600;
            //  NSInteger day = timeout/3600/24;
            NSInteger minutes = ((NSInteger)_timeInterval%3600) / 60;
            // NSInteger seconds = (timeout%3600) % 60;
            NSString *strTime = [NSString stringWithFormat:@"   您已经使用该车有%ld小时%ld分钟",(long)hou,(long)minutes];
            //设置界面的按钮显示 根据自己需求设置
            self.useCarTimeLabel.text = strTime;
            if ([self.Timer isValid]) {
                [self.Timer invalidate];
                _Timer = nil;
            }
            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            self.Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeYC_LabelShow) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.Timer forMode:NSRunLoopCommonModes];

        }
        }
    } fail:^(NSError *error) {
        [self.indeterHud hideAnimated:YES];
        [self initStringHudWith:@"请求失败"];
    }];
}
#pragma mark 倒计时

- (void)changeLabelShow
{
    _timeInterval--;
    
    if (_timeInterval<=0) {
        
        //设置界面的按钮显示 根据自己需求设置
        self.timeLabel.text = @"  剩余时间:0小时0分钟";
        _timeInterval = 1;
        [self cancelAppointWithOid:self.oid];
        //释放计时器
        [self.Timer invalidate];
        return;
    }
    //NSLog(@"%@",_note_Label_2.text);
    NSInteger hou = (NSInteger)_timeInterval/3600;
    //  NSInteger day = timeout/3600/24;
    NSInteger minutes = ((NSInteger)_timeInterval%3600) / 60;
    NSInteger seconds = ((NSInteger)_timeInterval%3600) % 60;
    if (seconds!= 0) {
        minutes+=1;
    }
    NSString *strTime = [NSString stringWithFormat:@"  剩余时间:%ld小时%ld分钟",hou,minutes];
    //设置界面的按钮显示 根据自己需求设置
    self.timeLabel.text = strTime;
}

- (void)changeYC_LabelShow
{
    _timeInterval++;
    
    NSInteger hou = (NSInteger)_timeInterval/3600;
    //  NSInteger day = timeout/3600/24;
    NSInteger minutes = ((NSInteger)_timeInterval%3600) / 60;
    // NSInteger seconds = (timeout%3600) % 60;
    NSString *strTime = [NSString stringWithFormat:@"您已经使用该车有%ld小时%ld分钟",hou,minutes];
    //NSLog(@"%@",_note_Label_2.text);
    //设置界面的按钮显示 根据自己需求设置
    self.timeLabel.text = strTime;
    
}

//取消预约订单
- (void)cancelAppointWithOid:(NSString *)oid{
    [self indeterminateShow];
    [InternetEngine postDataWithUrl:SERVER_IP(@"2006") parameters:@{@"oid":oid} success:^(id result) {
        [self.indeterHud hideAnimated:YES];
        if (result) {
            NSDictionary * dic = result;
            //                NSLog(@"%@",dic);
            if ([dic[@"result"] isEqualToNumber:@0]) {
                
                flag = 0;
                isAppoint = NO;
                self.appointOrRentView.hidden = YES;
                
            }
        }
    } fail:^(NSError * error) {
        [self.indeterHud hideAnimated:YES];
        [self initStringHudWith:@"请求失败"];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    flag = 0;
    NSLog(@"disappear");
}
//定位
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *curLocation = [locations lastObject];
    //    通过location  或得到当前位置的经纬度
    CLLocationCoordinate2D curCoordinate2D=curLocation.coordinate;
    NSLog(@"定位%f%f",curCoordinate2D.longitude,curCoordinate2D.latitude);
    
    MapView.camera=[GMSCameraPosition cameraWithLatitude:curCoordinate2D.latitude longitude:curCoordinate2D.longitude zoom:14];
}
//添加大头针
- (void)addAnnotionWith:(NSArray *)array{
    for (NSDictionary * dic in array){
        float lat = [[NSString stringWithString:dic[@"lat"]] floatValue];
        float lng = [[NSString stringWithString:dic[@"lng"]] floatValue];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.position = CLLocationCoordinate2DMake(lat, lng);
        marker.title = [NSString stringWithFormat:@"%@", dic[@"no"]];
        marker.icon = [UIImage imageNamed:@"bike"];
        //    marker.snippet = @"Australia";
        marker.map = MapView;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.numberTextField resignFirstResponder];
}

//限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    return [self validateNumber:string];
    
}
- (BOOL)validateNumber:(NSString*)number {
    
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange strRange = [string rangeOfCharacterFromSet:tmpSet];
        if (strRange.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
