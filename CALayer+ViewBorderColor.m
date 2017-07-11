//
//  CALayer+ViewBorderColor.m
//  GoogleMap
//
//  Created by Jerry on 2017/6/5.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "CALayer+ViewBorderColor.h"

@implementation CALayer (ViewBorderColor)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
