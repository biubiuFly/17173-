//
//  17173Header.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/4.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "MJ17173Header.h"

@implementation MJ17173Header


- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pull_%lu", (unsigned long)i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];

    //设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%lu", (unsigned long)i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    //隐藏刷新时的文字
    self.stateLabel.hidden = YES;
    //隐藏最后更新时间信息
    self.lastUpdatedTimeLabel.hidden = YES;
}


@end
