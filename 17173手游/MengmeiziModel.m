//
//  MengmeiziModel.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/5.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "MengmeiziModel.h"

@implementation MengmeiziModel
- (instancetype)initWithWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
