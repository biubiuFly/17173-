//
//  VideoModel.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/12.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
@property (nonatomic,strong)NSString *picUrl;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSNumber *playedTimes;
@property (nonatomic,strong)NSString *gameName;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
