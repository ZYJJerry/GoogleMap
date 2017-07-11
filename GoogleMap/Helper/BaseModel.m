//
//  BaseModel.m
//  Health
//
//  Created by Jerry on 16/2/25.
//  Copyright © 2016年 周玉举 All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    ////NSLog(@"%@",key);
}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}


//去掉html标签
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        
    }
//    NSScanner * scanner2 = [NSScanner scannerWithString:html];
//    NSString * text2 = nil;
//    while([scanner2 isAtEnd]==NO)
//    {
//        //找到标签的起始位置
//        [scanner2 scanUpToString:@"&" intoString:nil];
//        //找到标签的结束位置
//        [scanner2 scanUpToString:@";" intoString:&text2];
//        //替换字符
//        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@;",text2] withString:@":"];
//    }
//    NSMutableString *str = [NSMutableString stringWithString:html];
//    NSRange range = [str rangeOfString:@":" options:NSBackwardsSearch];
//    [str replaceCharactersInRange:range withString:@""];
    
    //NSString * regEx = @"<([^>]*)>";
//    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

@end
