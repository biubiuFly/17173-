//
//  glxjModel.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface glxjModel : NSObject
@property (nonatomic,strong) NSString *picUrl;
@property (nonatomic,strong) NSString *name;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
