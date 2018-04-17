//
//  NetworkObject.m
//  111
//
//  Created by 王俊杰 on 2018/3/27.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "NetworkObject.h"
#import<CommonCrypto/CommonDigest.h>
//#import "MainObject.h"
typedef NS_ENUM(NSInteger, NetworkRequestType) {
    NetworkRequestTypeGET,  // GET请求
    NetworkRequestTypePOST,  // POST请求
};

@implementation NetworkObject

#pragma mark -- 网络判断 --
+(void)AFNReachability
{
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown     = 未知
     AFNetworkReachabilityStatusNotReachable   = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WWAN" object:nil];
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WiFi" object:nil];
        }else if (status == AFNetworkReachabilityStatusUnknown){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"未知" object:nil];
        }else if (status == AFNetworkReachabilityStatusNotReachable){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"没有网络" object:nil];
        }
    }];
    
    
    //3.开始监听
    [manager startMonitoring];
}
//Start to get the data开始获取数据
#pragma mark -- GET请求 --
+ (void)getNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache isUpdate:(BOOL)update tableName:(NSString *)tableName succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    NSLog(@"下载图片1----%@",[NSThread currentThread]);

    [SQLObject creatSQLTableName:tableName];//创建名为OneViewController.sqlite的数据库，数据库名称不能一样，所以使用类名

    
    if (update == YES) {//如果更新数据库
        [self requestType:NetworkRequestTypeGET url:urlString parameters:parameters isCache:isCache isUpdate:update tableName:tableName succeed:succeed fail:fail];
    }else{//如果不更新数据库
        if ([SQLObject SQLTableName:tableName] == nil) {//如果缓存是空值，去服务器请求数据并且存到SQL
            [self requestType:NetworkRequestTypeGET url:urlString parameters:parameters isCache:isCache isUpdate:update tableName:tableName succeed:succeed fail:fail];
        }else{//如果数据库有值，就用数据库的值
            
            id dict = [NSJSONSerialization JSONObjectWithData:[SQLObject SQLTableName:tableName] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            //            NSLog(@" ===\n %@",dict);
            if (succeed) {
                succeed(dict);
            }
        }
    }
}

#pragma mark -- POST请求 --
+ (void)postNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache isUpdate:(BOOL)update tableName:(NSString *)tableName succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    NSLog(@"下载图片1----%@",[NSThread currentThread]);

    [SQLObject creatSQLTableName:tableName];//创建名为OneViewController.sqlite的数据库，数据库名称不能一样，所以使用类名

    
    if (update == YES) {//如果更新数据库
        [self requestType:NetworkRequestTypePOST url:urlString parameters:parameters isCache:isCache isUpdate:update tableName:tableName succeed:succeed fail:fail];
    }else{//如果不更新数据库
        if ([SQLObject SQLTableName:tableName] == nil) {//如果缓存是空值，去服务器请求数据并且存到SQL
            [self requestType:NetworkRequestTypePOST url:urlString parameters:parameters isCache:isCache isUpdate:update tableName:tableName succeed:succeed fail:fail];
        }else{//如果数据库有值，就用数据库的值
            
            id dict = [NSJSONSerialization JSONObjectWithData:[SQLObject SQLTableName:tableName] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (succeed) {
                succeed(dict);
            }
        }
    }
}
#pragma mark -- 网络请求 --
/**
 *  网络请求
 *
 *  @param type       请求类型，get请求/Post请求
 *  @param urlString  请求地址字符串
 *  @param parameters 请求参数

 *  @param succeed    请求成功回调
 *  @param fail       请求失败回调
 */
+ (void)requestType:(NetworkRequestType)type url:(NSString *)urlString parameters:(id)parameters  isCache:(BOOL)isCache isUpdate:(BOOL)update tableName:(NSString *)tableName succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    NSLog(@"下载图片1----%@",[NSThread currentThread]);

//    //1.获得全局的并发队列
//    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    if (type == NetworkRequestTypeGET) {
        // GET请求
        [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，，解析数据
            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            if (isCache == YES) {//如果缓存
                if (succeed) {
                    succeed(dict);
//                    dispatch_async(dispatch_get_global_queue(0, 2), ^{
//                        // 处理耗时操作的代码块...
//                        [SQLObject insertData:responseObject];//把服务器数据存到数据库
//                    });
                    
                    [SQLObject insertData:responseObject tableName:tableName];//把服务器数据存到数据库


                }
            }else{//如果不缓存
                if (succeed) {
                    succeed(dict);
                }
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            if (fail) {
                fail(error);
            }
        }];
        
    }else{
        
        NSLog(@"下载图片1----%@",[NSThread currentThread]);

//        //2.添加任务到队列中，就可以执行任务
//        //异步函数：具备开启新线程的能力
//        dispatch_async(queue, ^{
//
//        });
        // POST请求
        [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            // 请求的进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，解析数据
            
            NSLog(@"下载图片1----%@",[NSThread currentThread]);
            
            
            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            NSLog(@" ===\n %@",dict);
            
//            NSMutableArray *mArr = [NSMutableArray new];
//            for (int i = 0; i<[[dict valueForKey:@"carlist"] count]; i++) {
//                MainObject *ob = [MainObject new];
//                ob.car_infoname = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"carlist"][i] valueForKey:@"car_infoname"]];
//                ob.ID = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"carlist"][i] valueForKey:@"id"]];
//                [mArr addObject:ob];
//            }
            
            //创建一个并行队列
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (succeed) {
                    succeed(dict);
                }
            });
            
            
            if (isCache == YES) {//如果缓存
                //创建一个并行队列
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [SQLObject insertData:responseObject tableName:tableName];//把服务器数据存到数据库
                });
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            if (fail) {
                fail(error);
            }
        }];
        
    }
}


+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}


@end
