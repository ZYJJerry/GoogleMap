//
//  UIView+Addition.h
//  HelperProject
//
//  Created by Jerry on 16/2/25.
//  Copyright © 2016年 周玉举 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

- (CGFloat)width;

- (CGFloat)height;

- (CGFloat)left;

- (CGFloat)right;

- (CGFloat)top;

- (CGFloat)bottom;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

- (void)setXOffset:(CGFloat)x;

- (void)setYOffset:(CGFloat)y;

- (void)setOrigin:(CGPoint)newOrigin;

- (void)setSize:(CGSize)newSize;

@end





