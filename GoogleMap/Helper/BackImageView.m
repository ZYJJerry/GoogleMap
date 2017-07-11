//
//  BackImageView.m
//  FindBike1.1
//
//  Created by Jerry on 16/7/8.
//  Copyright © 2016年 周玉举 All rights reserved.
//

#import "BackImageView.h"
#import "HelperDefine.h"
@implementation BackImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:effectView];
        [self createImageView];
    }
    return self;
}

- (void)createImageView{
    self.iconImage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconImage.frame = CGRectMake(ScreenWidth/2-50, ScreenWidth-140, 100, 100);
    self.iconImage.backgroundColor = [UIColor grayColor];
    self.iconImage.layer.borderWidth = 2.f;
    self.iconImage.layer.borderColor = RGB(240, 240, 240).CGColor;
    [self addSubview:self.iconImage];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
