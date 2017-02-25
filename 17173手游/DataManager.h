//
//  DataManager.h
//  GameTest
//
//  Created by Peter Kong on 16/11/26.
//  Copyright © 2016年 Peter Kong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject


+(DataManager *)sharedDataManager;

//存储数据
-(void)SaveDataToDataBase:(NSDictionary *)dict withName:(NSString *)name;

//读取数据
-(NSDictionary *)LoadDatawithName:(NSString *)name;


@end
