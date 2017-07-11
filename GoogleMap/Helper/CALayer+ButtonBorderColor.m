//
//  CALayer+ButtonBorderColor.m
//  
//
//  Created by Jerry on 16/7/11.
//  Copyright © 2016年 周玉举 All rights reserved.
//

#import "CALayer+ButtonBorderColor.h"
#import <UIKit/UIKit.h>
@implementation CALayer (ButtonBorderColor)
- (void)setBorderColorWithUIColor:(UIColor *)color

{
    
    self.borderColor = color.CGColor;
    
}
@end
