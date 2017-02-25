//
//  MyNavBar.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/3.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "MyNavBar.h"

@implementation MyNavBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)changeBtn_leftImage
{
    [self.btn_left setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
}
- (IBAction)click_left:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(click_left)]) {
        [self.delegate click_left];
    }
}
- (IBAction)click_right:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(click_right)]) {
        [self.delegate click_right];
    }
}

@end
