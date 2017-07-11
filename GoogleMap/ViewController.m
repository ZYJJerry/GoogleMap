//
//  ViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/2.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate>
{
    GMSMapView * mapView;
}
@property (nonatomic,strong)CLLocationManager * locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.12 longitude:117.20 zoom:14];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.delegate = self;
    mapView.myLocationEnabled = YES;
    
    self.view = mapView;
    [self location];
    //    [mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:mapView.myLocation.coordinate.latitude longitude:mapView.myLocation.coordinate.longitude zoom:14]];
}

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
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{

        CLLocation *curLocation = [locations lastObject];
        //    通过location  或得到当前位置的经纬度
        CLLocationCoordinate2D curCoordinate2D=curLocation.coordinate;
    NSLog(@"%f%f",curCoordinate2D.longitude,curCoordinate2D.latitude);
    
        mapView.camera=[GMSCameraPosition cameraWithLatitude:curCoordinate2D.latitude longitude:curCoordinate2D.longitude zoom:14];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addAnnotion];
    });
    
    
}

- (void)addAnnotion{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(39.12, 117.20);
    marker.title = @"80001";
    marker.icon = [UIImage imageNamed:@"bike"];
    //    marker.snippet = @"Australia";
    marker.map = mapView;
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(39.12, 117.198);
    GMSMarker * mark = [GMSMarker markerWithPosition:position];
    mark.icon = [UIImage imageNamed:@"bike"];
    mark.title = @"01977";
    mark.map = mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
