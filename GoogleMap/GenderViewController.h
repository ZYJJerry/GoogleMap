//
//  GenderViewController.h
//  GoogleMap
//
//  Created by Jerry on 2017/6/16.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import "BaseViewController.h"

@protocol changUserGender <NSObject>

- (void)changeGender:(NSInteger)gender;

@end
@interface GenderViewController : BaseViewController
@property (nonatomic,assign)NSInteger flag;

@property (nonatomic,assign)id<changUserGender> delegate;

@end
