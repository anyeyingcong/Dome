//
//  NetworkObject.h
//  111
//
//  Created by 王俊杰 on 2018/3/27.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkObject : NSObject
/**
 *  监听网络状态,程序启动执行一次即可
 */
+ (void)AFNReachability;


+ (void)getNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache isUpdate:(BOOL)update tableName:(NSString *)tableName succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;
/**
 *  Post请求 <若开启缓存，先读取本地缓存数据，再进行网络请求，>
 *
 *  @param urlString  请求地址
 *  @param parameters 拼接的参数
 *  @param isCache    是否开启缓存机制
 *  @param succeed    请求成功
 *  @param fail       请求失败
 */
+ (void)postNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache isUpdate:(BOOL)update tableName:(NSString *)tableName succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;


+(NSString *) md5: (NSString *) inPutText;

+ (NSString*)iphoneType;

@end
