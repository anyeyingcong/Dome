//
//  SQLObject.m
//  111
//
//  Created by 王俊杰 on 2018/3/28.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import "SQLObject.h"

//static FMDatabase *_db;

@implementation SQLObject

{
    NSString *maxID;
}

+(void)creatSQLTableName:(NSString *)tableName{//创建数据库
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tableName]];
    //2.获取数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    if ([db open]) {
        NSLog(@"打开数据库成功");
        
        //        NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", @"user_information" ];
        
        //监测数据库中我要需要的表是否已经存在
        NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", @"SQL_DATA" ];
        FMResultSet *rs = [db executeQuery:existsSql];
        
        if ([rs next]) {
            NSInteger count = [rs intForColumn:@"countNum"];
            //            NSLog(@"The table count: %li", count);
            if (count == 1) {
                NSLog(@"存在");
//                NSLog(@"%@", [_db executeQuery:@"select max id from SQL_DATA"]);
                return;
            }else{
                //4.创表
                BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS SQL_DATA (id integer PRIMARY KEY AUTOINCREMENT, data text NOT NULL);"];
                if (result)
                {
                    NSLog(@"创建表成功");
//                    NSLog(@"%@", [_db executeQuery:@"select max id from SQL_DATA"]);
                    
                }else {
                    NSLog(@"创建表失败");
                }
                return;
            }
        }
    } else {
        NSLog(@"打开数据库失败");
    }
}


+(void)insertData:(NSData *)data tableName:(NSString *)tableName{
    NSLog(@"下载图片1----%@",[NSThread currentThread]);

//    NSLog(@" ===\n %@",data);
    //    BOOL result = [_db executeQuery:@"select * from SQL_DATA order by id desc LIMIT 1"];//降序排列 取最后一个ID
    
    //    [_db executeQuery:@"select max id from SQL_DATA"]表SQL_DATA中的最大ID
    
    
    //self.responseObject
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tableName]];
    //2.获取数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    
    NSString *maxid;
    
    if ([db open]) {
        
        // 根据请求参数查询数据
        FMResultSet *resultSet = nil;
        //@"select *from user_information"    select * from personalCenter_data order by rowid DESC limit 1
        resultSet = [db executeQuery:@"select * from SQL_DATA order by rowid DESC limit 1"];//根据roeid取最大的id值
        
        
        // 遍历查询结果
        while (resultSet.next) {
            
            maxid = [resultSet stringForColumn:@"id"];
//            NSLog(@" ===\n %@",[resultSet stringForColumn:@"id"]);

        }
    }
    
    
    if (maxid == nil) {
        
        BOOL result = [db executeUpdate:@"INSERT INTO SQL_DATA (data) VALUES (?);",data];//如果表是空值  就插入一条数据
        if (result) {
            NSLog(@" 插入成功");
        }else{
            NSLog(@" 插入失败");
        }
        
    } else {
        
        BOOL result =[db executeUpdate:@"UPDATE SQL_DATA  SET data=? WHERE id=?",data,maxid];//如果表有值   就更新  数据
        if (result) {
            NSLog(@" 更新成功");
        }else{
            NSLog(@" 更新失败");
        }
    }

}
//
//
//
+(NSData *)SQLTableName:(NSString *)tableName{
    
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tableName]];
    //2.获取数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    NSString *dataString;

    if ([db open]) {

        // 根据请求参数查询数据
        FMResultSet *resultSet = nil;
        //@"select *from user_information"    select * from personalCenter_data order by rowid DESC limit 1
        resultSet = [db executeQuery:@"select * from SQL_DATA order by rowid DESC limit 1"];
        
        
        // 遍历查询结果
        while (resultSet.next) {

//            NSLog(@" ===\n %@",[resultSet stringForColumn:@"data"]);

            dataString = [resultSet stringForColumn:@"data"];
        }

    }
    return [dataString dataUsingEncoding:NSUTF8StringEncoding];//NSString转NSData
}
@end
