//
//  NSString+Extension.h
//
//
//  Created by Jerry on 16/7/11.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
//判断是不是手机号
- (BOOL)isPhoneNumber;
//判断是不是IP地址
- (BOOL)isIPAddress;
//判断是不是登录密码(6到16位)
- (BOOL)isPassWord;
//判断登录密码是否包含数字字母下划线(6到10位)
@end
