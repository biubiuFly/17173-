//
//  DataManager.m
//  GameTest
//
//  Created by Peter Kong on 16/11/26.
//  Copyright © 2016年 Peter Kong. All rights reserved.
//

#import "DataManager.h"
#import "FMDB.h"

@interface DataManager ()

@property (nonatomic,strong) FMDatabase *db;

@end


@implementation DataManager


static DataManager * sharedDataManagerInstance = nil;

//初始化方法
+(DataManager *)sharedDataManager
{

    //2.声明一个安全的线程，整个软件内只执行一次的线程
    static dispatch_once_t predicate;
    
    //3.在这个线程中创建这个对象
    dispatch_once(&predicate, ^{
        sharedDataManagerInstance = [[self alloc]init];
        [sharedDataManagerInstance openDB];
    });
    
    //4.返回这个对象
    return sharedDataManagerInstance;
}

-(void)SaveDataToDataBase:(NSDictionary *)dict withName:(NSString *)name
{
    [self openDB];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    

    FMResultSet *set = [self.db executeQuery:@"SELECT COUNT(*) FROM t_index WHERE name = ?",name];
    
    int count = 0;
    while ([set next]) {
        count = [set intForColumn:@"COUNT(*)"];
    }
    if (count==0) {
        bool su = [self.db executeUpdate:@"INSERT INTO t_index(name,data) VALUES(?,?)",name,data];
        if (su) {
            NSLog(@"原数据为空，插入%@数据成功",name);
        }else{
            NSLog(@"插入%@数据失败",name);
        }
    }else{
        bool su = [self.db executeUpdate:@"UPDATE t_index SET data = ? WHERE name = ?",data,name];
        if (su) {
            NSLog(@"%@数据更新成功",name);
        }else{
            NSLog(@"%@数据更新失败",name);
        }
    }

    
}

-(void)openDB
{
    if (self.db == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = paths[0];
        path = [path stringByAppendingPathComponent:@"17173.sqlite"];
        
        self.db = [FMDatabase databaseWithPath:path];
        [self.db open];
        
        //直接创建表
        NSString *sql = @"CREATE TABLE IF NOT EXISTS t_index (id INTEGER PRIMARY KEY AUTOINCREMENT,name text,data blob)";
        bool su =[self.db executeUpdate:sql];
        
        if (su) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
    }
}

-(NSDictionary *)LoadDatawithName:(NSString *)name
{
    [self openDB];
    
    FMResultSet *set = [self.db executeQuery:@"SELECT * FROM t_index WHERE name = ?",name];
    id dict;
    while ([set next]) {
        
        //dataForColumn
        dict = [NSJSONSerialization JSONObjectWithData:[set dataForColumn:@"data"] options:NSJSONReadingMutableContainers error:nil];
        
        
    }
    return dict;
}



@end
