//
//  MyRootRequest.m
//  Block - 02
//
//  Created by Peter Kong on 16/11/10.
//  Copyright © 2016年 Peter Kong. All rights reserved.
//

#import "MyRootRequest.h"

@implementation MyRootRequest

/*
    错误的使用方式:
    1.NSError * _Nullable error - 返回的参数里面有error - 直接判断error是否存在
 
    2.初始化的时候error参数让你传进去:
     新建一个空的NSError指针，当做参数传进去
     运行初始化程序后判断你的NSError指针是不是有值。
 */

+(void)GetUrlWithString:(NSString *)urlStr WithHeader:(NSDictionary *)HeaderD WithRequestSuccess:(ResponseSuccess)sucessBlock WithRequestFailed:(ResponseFailed)failedBlock{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *re = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:5];
    
    //添加Header
    for (NSString *key in HeaderD.allKeys) {
        [re setValue:HeaderD[key] forHTTPHeaderField:key];
    }
    
    //都是异步获取
    NSURLSessionTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:re completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //网络成功方法
        if (error == nil) {
            
            NSError *error_json;
            
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error_json];
            
            
            //主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error_json != nil) {
                    //Json解析错误
                    if (failedBlock != nil) {
                        failedBlock(error_json);
                    }
                }else{
                    //Json解析成功
                    if (sucessBlock != nil) {
                        sucessBlock(object);
                    }
                    
                }
            });
            
        }else{
            //网络失败的方法
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failedBlock != nil) {
                    failedBlock(error);
                }
            });
        }
        
    }];
    
    //网络开始执行
    [task resume];

}


+(void)GetUrlWithString:(NSString *)urlStr WithRequestSuccess:(ResponseSuccess)sucessBlock WithRequestFailed:(ResponseFailed)failedBlock
{
    [MyRootRequest GetUrlWithString:urlStr WithHeader:nil WithRequestSuccess:sucessBlock WithRequestFailed:failedBlock];
}

+(void)PostUrlWithString:(NSString *)urlStr WithHeaderDict:(NSDictionary *)headerD WithParam:(NSDictionary *)params WithRequestSuccess:(ResponseSuccess)sucessBlock WithRequestFailed:(ResponseFailed)failedBlock
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *re = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:5];
    
    //修改Post请求
    [re setHTTPMethod:@"POST"];
    
    //添加Header
    //遍历字典
    for (NSString *key in headerD.allKeys) {
        [re setValue:headerD[key] forHTTPHeaderField:key];
    }
    
    //字典转data
    NSData *body = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    
    
    [re setHTTPBody:body];
    
    //都是异步获取
    NSURLSessionTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:re completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //网络成功方法
        if (error == nil) {
            
            NSError *error_json;
            
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error_json];
            
            
            //主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error_json != nil) {
                    //Json解析错误
                    if (failedBlock != nil) {
                        failedBlock(error_json);
                    }
                }else{
                    //Json解析成功
                    if (sucessBlock != nil) {
                        sucessBlock(object);
                    }
                    
                }
            });
            
        }else{
            //网络失败的方法
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failedBlock != nil) {
                    failedBlock(error);
                }
            });
        }
        
    }];
    
    //网络开始执行
    [task resume];
}


+(void)PostUrlWithString:(NSString *)urlStr WithParam:(NSDictionary *)params WithRequestSuccess:(ResponseSuccess)sucessBlock WithRequestFailed:(ResponseFailed)failedBlock
{
    [MyRootRequest PostUrlWithString:urlStr WithHeaderDict:nil WithParam:params WithRequestSuccess:sucessBlock WithRequestFailed:failedBlock];
}



//上传图片
+(void)PostImageWithString:(NSString *)urlStr WithParam:(NSDictionary *)params AndImage:(UIImage *)image AndImageName:(NSString *)name WithRequestSuccess:(ResponseSuccess)sucessBlock WithRequestFailed:(ResponseFailed)failedBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",nil];
    

    
    NSURLSessionDataTask *task = [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        
        NSData *imageData;
        if (UIImagePNGRepresentation(image) == nil) {
            
            imageData = UIImageJPEGRepresentation(image, 1);
            
        } else {
            
            imageData = UIImagePNGRepresentation(image);
        }
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:name
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //上传成功
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (sucessBlock != nil) {
                sucessBlock(responseObject);
            }
            
        });
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (failedBlock != nil) {
                failedBlock(error);
            }
        });
            
    }];
    
    [task resume];
}

@end
