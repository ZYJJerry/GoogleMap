//
//  JourneyTableViewCell.h
//  GoogleMap
//
//  Created by Jerry on 2017/6/14.
//  Copyright © 2017年 周玉举. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JourneyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bikeNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
