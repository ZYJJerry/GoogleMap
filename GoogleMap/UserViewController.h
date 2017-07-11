//
//  UserViewController.h
//  GoogleMap
//
//  Created by Jerry on 2017/6/5.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol changeUserPhoto <NSObject>

- (void)changePhotoWithImage:(UIImage *)image;

@end
@interface UserViewController : BaseViewController

@property (nonatomic,strong)NSDictionary * dic;
@property (nonatomic,strong)UIImage * headImage;
@property (nonatomic,assign)id<changeUserPhoto> delegate;
@end
