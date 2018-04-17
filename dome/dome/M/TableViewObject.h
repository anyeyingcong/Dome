//
//  TableViewObject.h
//  dome
//
//  Created by 王俊杰 on 2018/4/16.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewObject : NSObject
@property (nonatomic) NSString *tid;//  编号
@property (nonatomic) NSString *title;//  标题
@property (nonatomic) NSString *comart;// 简介

@property (nonatomic) NSString *visit;//   浏览量
@property (nonatomic) NSString *forword;//   转发量
@property (nonatomic) NSString *image;//  缩略图


@property (nonatomic) NSString *describe;
@property (nonatomic) NSString *isopen;

@property (nonatomic) NSString *car_infoname;//  小帮手内容
@end
