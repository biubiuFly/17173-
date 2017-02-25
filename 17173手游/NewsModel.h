//
//  NewsModel.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/3.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *picUrl;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
