//
//  LaosijiModel.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/4.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaosijiModel : NSObject
@property (nonatomic, strong) NSString *MiddleCover;
@property (nonatomic, strong) NSNumber *Count;
@property (nonatomic, strong) NSString *Title;
- (instancetype)initWithWithDict:(NSDictionary *)dict;
@end
