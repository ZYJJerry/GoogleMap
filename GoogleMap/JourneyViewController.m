//
//  JourneyViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/7.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "JourneyTableViewCell.h"
#import "JourneyViewController.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "JourneyDetailViewController.h"
@interface  JourneyViewController()<UITabBarDelegate,UITableViewDataSource,UIScrollViewDelegate,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property (nonatomic, assign) NSInteger page_count;

@property (nonatomic, strong) NSMutableArray * LOGArray;
@end

@implementation JourneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.myTableview registerNib:[UINib nibWithNibName:@"JourneyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"journey"];
    [self.myTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.myTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
    self.myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _page_count = 1;
    self.LOGArray = [NSMutableArray array];
    [self requestData];
    // Do any additional setup after loading the view.
}
#pragma mark 下拉刷新
- (void)headerBeginRefreshing
{
    self.page_count = 1;
    [self.LOGArray removeAllObjects];
    [self requestData];
    [self.myTableview headerEndRefreshing];
    
}
#pragma mark 上拉加载
- (void)footerRereshing
{
    _page_count++;
    [self requestData];
    [self.myTableview footerEndRefreshing];
}
- (void)requestData{
    [self indeterminateShow];
    [InternetEngine postDataWithUrl:SERVER_IP(@"2021") parameters:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"page":[NSString stringWithFormat:@"%ld",_page_count],@"rows":@"10"} success:^(id result) {
        [self.intederHud hideAnimated:YES];
        if(result){
            NSDictionary * dic = result;
            NSLog(@"%@",dic);
            if ([dic[@"result"] isEqualToNumber:@0]) {
                NSArray *theArray = dic[@"data"];
                if (theArray.count > 0) {
                    [self.LOGArray addObjectsFromArray:theArray];
                }else if (self.LOGArray.count == 0)
                {
                    [self initStringHudWith:@"暂无记录"];
                }else if (self.LOGArray.count != 0&& theArray.count == 0)
                {
                    [self initStringHudWith:@"已加载全部"];
                }
                [self.myTableview reloadData];
            }else{
                [self initStringHudWith:dic[@"msg"]];
            }
        }else{
            [self initStringHudWith:@"请求失败"];
        }
    } fail:^(NSError *error) {
        [self.intederHud hideAnimated:YES];
        [self initStringHudWith:@"请求失败"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _LOGArray.count;
}
//设置cell上面的显示
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JourneyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"journey" forIndexPath:indexPath];
    if (_LOGArray.count>0) {
        NSDictionary * dic = self.LOGArray[indexPath.row];
        cell.timeLabel.text = dic[@"stime"];
        cell.bikeNoLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"车辆编号", nil),dic[@"vno"]];
        cell.rentTimeLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"骑行时间", nil),dic[@"duration"]];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"骑行费用", nil),dic[@"amt"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
//返回按钮
- (void)didClickToPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JourneyDetailViewController * jdvc = [[JourneyDetailViewController alloc]init];
    jdvc.dic = self.LOGArray[indexPath.row];
    [self.navigationController pushViewController:jdvc animated:YES];
}

/*
-(NSString *)getUTCFormateDate:(NSString *)newsDate
{
    //    newsDate = @"2013-08-09 17:01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //NSLog(@"newsDate = %@",newsDate);
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    int month=((int)time)/(3600*24*30);
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    //int minute=((int)time)%(3600*24)/60;
    //  NSLog(@"time=%d",(double)time);
    
    NSString *dateContent;
    
    if(month!=0){
        dateContent = newsDate;
    }else if(days!=0){
        NSTimeInterval S = 24*60*60;
        NSDate * today = [NSDate date];
        NSLog(@"%@",[[NSDate date] description]);
        NSDate * yesToday = [today dateByAddingTimeInterval:-S];
        if ([[newsDate substringToIndex:10] isEqualToString:[[yesToday description] substringToIndex:10]]) {
            
            dateContent = [NSString stringWithFormat:@"昨天:%@",[newsDate substringWithRange:NSMakeRange(10, 6)]];
        }else{
            dateContent = newsDate;
        }
        
        // dateContent = [NSString stringWithFormat:@"%@%i%@",@"",days,@"天前"];
    }else if(hours!=0){
        if ([[newsDate substringToIndex:10] isEqualToString:[[[NSDate date]description] substringToIndex:10]]) {
            dateContent = [NSString stringWithFormat:@"今天:%@",[newsDate substringWithRange:NSMakeRange(10, 6)]];
        }else{
            dateContent = [NSString stringWithFormat:@"昨天:%@",[newsDate substringWithRange:NSMakeRange(10, 6)]];
        }
        //dateContent = [NSString stringWithFormat:@"%@%i%@",@"",hours,@"小时前"];
    }else {
        NSLog(@"%@",[[NSDate date] description]);
        dateContent = [NSString stringWithFormat:@"今天:%@",[newsDate substringWithRange:NSMakeRange(10, 6)]];
        // dateContent = [NSString stringWithFormat:@"%@%i%@",@"",minute,@"分钟前"];
    }
    
    //    NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    return dateContent;
}
 */
//去掉 UItableview headerview 黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.myTableview)
    {
        CGFloat sectionHeaderHeight = 60; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
@end


