//
//  InternetEngine.h
//  LongChiAPP
//
//  Created by Jerry on 2017/3/21.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface InternetEngine : NSObject

//GET请求
+ (void)getDataWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id))success fail:(void (^)(NSError *))fail;
//POST请求
+ (void)postDataWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id))success fail:(void (^)(NSError *))fail;
@end
