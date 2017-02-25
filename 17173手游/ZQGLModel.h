//
//  ZQGLModel.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQGLModel : NSObject
@property (nonatomic,strong)NSString *namezq;
@property (nonatomic,strong)NSString *introduce;
@property (nonatomic,strong)NSString *itunesVersion;
@property (nonatomic,strong)NSString *iconUrl;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
