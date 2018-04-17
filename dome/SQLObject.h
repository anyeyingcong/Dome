//
//  SQLObject.h
//  111
//
//  Created by 王俊杰 on 2018/3/28.
//  Copyright © 2018年 刘讲话. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLObject : NSObject

//@property (nonatomic) NSString *docPath;
//
//@property (nonatomic) FMDatabase *db;//数据库
//
//@property (nonatomic) NSString *maxID;//数据库  自增的最大ID


+(void)creatSQLTableName:(NSString *)tableName;

+(void)insertData:(NSData *)data tableName:(NSString *)tableName;

+(NSData *)SQLTableName:(NSString *)tableName;

@end
