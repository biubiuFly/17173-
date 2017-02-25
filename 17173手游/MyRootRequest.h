//
//  MyRootRequest.h
//  Block - 02
//
//  Created by Peter Kong on 16/11/10.
//  Copyright © 2016年 Peter Kong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

/*
    MyRootReuest
    Get+Delegate    - 1.0
    Get+Block       - 2.0
    Post+Block      - 3.0
    Header+Block    - 4.0
    图片上传啊        - 5.0
 */


/*
    定义成功和失败的函数类型
 */
typedef void(^ResponseSuccess)(id object);
typedef void(^ResponseFailed)(NSError *error);


@interface MyRootRequest : NSObject


/**
 HTTP GET方法 + Header头
 
 @param urlStr      请求地址
 @param HeaderD     Header内容的字典
 @param sucessBlock 成功后的回调
 @param failedBlock 失败后的回调
 */
+(void)GetUrlWithString:(NSString *)urlStr WithHeader:(NSDictionary *)HeaderD WithRequestSuccess:(ResponseSuccess)sucessBlock WithRequestFailed:(ResponseFailed)failedBlock;


/**
 HTTP GET方法

 @param urlStr      请求地址
 @param sucessBlock 成功后的回调
 @param failedBlock 失败后的回调
 */
+(void)GetUrlWithString:(NSString *)urlStr WithRequestSuccess:(ResponseSuccess)sucessBlock WithRequestFailed:(ResponseFailed)failedBlock;

/**
 HTTP POST方法

 @param urlStr      请求地址
 @param param       参数体
 @param sucessBlock 成功后的回调
 @param failedBlock 失败后的回调
 */
+(void)PostUrlWithString:(NSString *)urlStr WithParam:(NSDictionary *)param WithRequestSuccess:(ResponseSuccess)sucessBlock WithRequestFailed:(ResponseFailed)failedBlock;


/**
 HTTP POST方法 + Header

 @param headerD     Header内容的字典
 @param urlStr      请求地址
 @param params       参数体
 @param sucessBlock 成功后的回调
 @param failedBlock 失败后的回调
 */
+(void)PostUrlWithString:(NSString *)urlStr WithHeaderDict:(NSDictionary *)headerD WithParam:(NSDictionary *)params WithRequestSuccess:(ResponseSuccess)sucessBlock WithRequestFailed:(ResponseFailed)failedBlock;

/**
 
 HTTP 上传图片的方法
 上传图片的方法

 @param urlStr      请求地址
 @param params       参数体
 @param image       上传的图片
 @param name        图片的名字
 @param sucessBlock 成功后的回调
 @param failedBlock 失败后的回调
 */
+(void)PostImageWithString:(NSString *)urlStr WithParam:(NSDictionary *)params AndImage:(UIImage *)image AndImageName:(NSString *)name WithRequestSuccess:(ResponseSuccess)sucessBlock WithRequestFailed:(ResponseFailed)failedBlock;



@end
