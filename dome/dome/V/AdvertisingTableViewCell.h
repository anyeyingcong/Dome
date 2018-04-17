//
//  AdvertisingTableViewCell.h
//  dome
//
//  Created by 王俊杰 on 2018/4/16.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertisingTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题

@property (weak, nonatomic) IBOutlet UIImageView *avatarsImgView;//广告图

@property (weak, nonatomic) IBOutlet UILabel *advertisingLab;//广告

@property (weak, nonatomic) IBOutlet UIButton *lookBut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgV_h;

@end
