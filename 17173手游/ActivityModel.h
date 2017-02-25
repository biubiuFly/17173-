//
//  ActivityModel.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/9.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *introduction;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
