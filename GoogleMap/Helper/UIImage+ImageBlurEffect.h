//
//  UIImage+ImageBlurEffect.h
//  BlurEffect
//
//  Created by zhouyuju on 16/1/28.
//  Copyright © 2016年 黄迅舟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageBlurEffect)

-(UIImage*)applyLightEffect;
-(UIImage*)applyExtraLightEffect;
-(UIImage*)applyDarkEffect;
-(UIImage*)applyTintEffectWithColor:(UIColor*)tintColor;
-(UIImage*)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage;

@end
