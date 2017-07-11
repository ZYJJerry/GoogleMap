//
//  NewsViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/7.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "URL.h"
#import "InternetEngine.h"
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger rows;
    NSInteger page;
    NSInteger status;
}
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property (weak, nonatomic) IBOutlet UILabel *detailContentLabel;
@property (nonatomic,strong)NSMutableArray * datasource;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"News";
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self initView];
    [self getNetData];
}
- (IBAction)dismissDetailView:(id)sender {
    self.detailView.hidden = YES;
    self.myTableview.hidden = NO;
}

- (void)getNetData{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [self indeterminateShow];
    [InternetEngine postDataWithUrl:SERVER_IP(@"2027") parameters:@{@"uid":[user valueForKey:@"userId"],@"sts":[NSString stringWithFormat:@"%ld",status],@"rows":[NSString stringWithFormat:@"%ld",rows],@"page":[NSString stringWithFormat:@"%ld",page]} success:^(id result) {
        [self.intederHud hideAnimated:YES];
        NSDictionary * dic = result;
        if ([dic[@"result"] isEqualToNumber:@0]) {
            NSLog(@"%@",dic);
            self.datasource = dic[@"data"];
            [self.myTableview reloadData];
        }
        
    } fail:^(NSError * error) {
        
    }];
}

- (void)initData{
    self.datasource = [NSMutableArray new];
    page = 1;
    rows = 10;
    status = 2;
}

- (void)initView{
    [self.myTableview registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"news"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"news";
    NewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSDictionary * dic = self.datasource[indexPath.row];
    cell.titleLabel.text = dic[@"title"];
    cell.contentLabel.text = dic[@"content"];
    cell.timeLabel.text = [self getUTCFormateDate:dic[@"date"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

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
    int minute=((int)time)%(3600*24)/60;
    //  NSLog(@"time=%d",(double)time);
    
    NSString *dateContent;
    
    if(month!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"",month,@"个月前"];
        
    }else if(days!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"",days,@"天前"];
    }else if(hours!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"",hours,@"小时前"];
    }else {
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"",minute,@"分钟前"];
    }
    
    //    NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    return dateContent;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.datasource[indexPath.row];
    self.detailTitleLabel.text = dic[@"title"];
    self.detailContentLabel.text = dic[@"content"];
    self.detailTimeLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"发布时间", nil),[self getUTCFormateDate:dic[@"date"]]];
    self.myTableview.hidden = YES;
    self.detailView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    self.detailView.hidden = YES;
    self.myTableview.hidden = NO;
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
