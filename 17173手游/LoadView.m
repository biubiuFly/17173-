//
//  LoadView.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/7.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "LoadView.h"

@interface LoadView ()
@property (weak, nonatomic) IBOutlet UIImageView *image_view;

@end
@implementation LoadView


-(void)awakeFromNib
{
    [super awakeFromNib];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i<=8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%d",i]];
        [arr addObject:image];
    }
    self.image_view.animationImages = arr;
    self.image_view.animationDuration = 1;
    [self.image_view startAnimating];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
