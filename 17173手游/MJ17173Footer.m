//
//  MJ17173Footer.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/4.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "MJ17173Footer.h"

@implementation MJ17173Footer

- (void)prepare
{
    [super prepare];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loadState%lu", (unsigned long)i]];
        //那个圈圈太大按比例缩小一点
        [refreshingImages addObject:[self scaleImage:image toScale:0.7]];
    }
    
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    //重新自定义刷新文字与动画之间的距离
    self.labelLeftInset = 5;
    //自定义刷新时文字
    [self setTitle:@"正在加载更多" forState:MJRefreshStateRefreshing];
}
//按比率缩放图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    return scaledImage;
}

@end
