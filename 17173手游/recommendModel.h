//
//  recommendModel.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recommendModel : NSObject
@property (nonatomic,strong)NSString *iconUrl;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *introduce;
@property (nonatomic,strong)NSString *dingyue;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
