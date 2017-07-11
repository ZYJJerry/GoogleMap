//
//  HelperDefine.h
//  Homework
//
//  Created by Jerry on 16/2/25.
//  Copyright © 2016年 周玉举 All rights reserved.
//

#ifndef HelperDefine_h
#define HelperDefine_h

//定义RGB值
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define RGB(r, g, b) RGBA(r, g, b, 1.f)
#define RandomColor RGB(arc4random()%256, arc4random()%256, arc4random()%256)

//44是一个特殊的常量，默认行高和NavigationBar的高度为44
#define Default 44
//距离左边边距为10
#define LeftDistance 10
//控件间的距离
#define ControlDistance 20
//定义屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//定义屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark - Color
#define WhiteColor [UIColor whiteColor]
#define BlackColor [UIColor blackColor]
#define BlueColor [UIColor blueColor]
#define YellowColor [UIColor yellowColor]
#define GreenColor [UIColor greenColor]
#define OrangeColor [UIColor orangeColor]
#define ClearColor [UIColor clearColor]
#define GrayColor [UIColor grayColor]
#define CyanColor [UIColor cyanColor]
#define SkyColor RGB(38, 187, 251)
#define RedColor [UIColor redColor]
#define red RGB(217,55,104)

//十六进制颜色转换
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* HelperDefine_h */








