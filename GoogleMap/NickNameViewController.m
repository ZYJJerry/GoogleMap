//
//  NickNameViewController.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/16.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "NickNameViewController.h"

@interface NickNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nickNameTextField.text = self.nickName;
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
