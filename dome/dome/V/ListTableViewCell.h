//
//  ListTableViewCell.h
//  dome
//
//  Created by 王俊杰 on 2018/4/16.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UILabel *timerLab;
@property (weak, nonatomic) IBOutlet UILabel *forwardingLab;//转发量
@property (weak, nonatomic) IBOutlet UILabel *browseLab;//浏览量

@property (weak, nonatomic) IBOutlet UIImageView *avatarsImgView;
@end
