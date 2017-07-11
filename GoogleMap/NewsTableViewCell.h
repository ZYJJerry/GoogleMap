//
//  NewsTableViewCell.h
//  GoogleMap
//
//  Created by Jerry on 2017/6/19.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
