//
//  AlertMonmentView.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/6.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "AlertMonmentView.h"
#define SW [UIScreen mainScreen].bounds.size.width
#define SH [UIScreen mainScreen].bounds.size.height
@implementation AlertMonmentView

+ (UIView *)createSubViewWithText:(NSString *)text WithWidth:(CGFloat)width WithHeight:(CGFloat)height
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(SW/2-width/2, SH-60-64-height, width, height)];
    view.backgroundColor = [UIColor blackColor];
    view.layer.cornerRadius = 10;
    view.alpha = 1;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = text;
    label.font = [UIFont systemFontOfSize:13];
    [view addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    });

    return view;
}

@end
