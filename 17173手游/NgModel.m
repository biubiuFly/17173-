//
//  NgModel.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/8.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "NgModel.h"

@implementation NgModel
-(instancetype)initWithDict:(NSDictionary *)dict
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
