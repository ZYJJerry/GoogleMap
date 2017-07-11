//
//  JourneyDetailViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/15.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "JourneyDetailViewController.h"
#import "InternetEngine.h"
#import "UIImageView+AFNetworking.h"
#import "UICountingLabel.h"
@interface JourneyDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *journeyImageView;
@property (weak, nonatomic) IBOutlet UICountingLabel *priceLebel;
@property (weak, nonatomic) IBOutlet UILabel *bikeNoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@end

@implementation JourneyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.dic);
    self.firstButton.userInteractionEnabled = NO;
    self.secondButton.userInteractionEnabled = NO;
    self.thirdButton.userInteractionEnabled = NO;
    [self showDataWithDictionary:self.dic];
}

- (void)showDataWithDictionary:(NSDictionary *)dictionary{
    self.bikeNoLabel.text = dictionary[@"vno"];
    [self.journeyImageView setImageWithURL:[NSURL URLWithString:dictionary[@"locusUrl"]]];
    if ([dictionary[@"amt"] floatValue] == 0) {
        self.priceLebel.text = dictionary[@"amt"];
    }else{
    self.priceLebel.method = UILabelCountingMethodEaseInOut;
    self.priceLebel.format = @"%.2f";
//    __weak JourneyDetailViewController* blockSelf = self;
//    self.bikeNoLabel.completionBlock = ^{
//        blockSelf.bikeNoLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//    };
    [self.priceLebel countFrom:0 to:[dictionary[@"amt"] floatValue]];
    }
    
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
