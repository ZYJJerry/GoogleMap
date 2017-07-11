//
//  NSString+Extension.m
//
//
//  Created by Jerry on 16/7/11.
//
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL)match:(NSString *)pattern
{
    // 创建正则表达式
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return results.count > 0;
}

/**
 *  电话号码
 *
 *  @return 布尔类型
 */
- (BOOL)isPhoneNumber
{
    // 1.全部是数字
    // 2.11位
    // 3.以13\15\18\17开头
    return [self match:@"^1[3578]\\d{9}$"];
    
}
/**
 * IP地址
 *  @return 布尔类型
 */
- (BOOL)isIPAddress
{
    // 1-3个数字: 0-255
    // 1-3个数字.1-3个数字.1-3个数字.1-3个数字
    return [self match:@"^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$"];
}

/**
 *  包含数字和字母的密码(6到16位)
 *
 *  @return 布尔类型
 */

- (BOOL)isPassWord{

    return [self match:@"^[A-Za-z0-9.-_@!?#]{6,16}$"];
}
/**
 *  必须包含数字字母下划线的密码(6到16位)
 *
 *  @return 布尔类型
 */
- (BOOL)passWordContens{
    return [self match:@"^((?=.*[0-9].*)(?=.*[A-Za-z].*)(?=.*_.*))[_0-9A-Za-z]{6,16}$"];
}


@end
