//
//  GenderViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/16.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "GenderViewController.h"

@interface GenderViewController ()

@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIImageView *maleImageView;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIImageView *femaleImageView;
@end

@implementation GenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maleButton.layer.borderWidth = 1.f;
    self.maleButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.femaleButton.layer.borderWidth = 1.f;
    self.femaleButton.layer.borderColor = [UIColor grayColor].CGColor;
    if (self.flag == 1) {
        self.maleImageView.hidden = NO;
        self.femaleImageView.hidden = YES;
    }else if (self.flag == 2){
        self.maleImageView.hidden = YES;
        self.femaleImageView.hidden = NO;
    }
}
- (IBAction)selectMale:(id)sender {
    self.flag = 1;
    self.maleImageView.hidden = NO;
    self.femaleImageView.hidden = YES;
}
- (IBAction)selectFemale:(id)sender {
    self.flag = 2;
    self.maleImageView.hidden = YES;
    self.femaleImageView.hidden = NO;
}

- (IBAction)confirmChangeGender:(id)sender {
    [self.delegate changeGender:self.flag];
    [self.navigationController popViewControllerAnimated:YES];
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
