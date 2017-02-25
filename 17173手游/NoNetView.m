//
//  NoNetView.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/6.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "NoNetView.h"

@interface NoNetView ()

@property (nonatomic, strong) ClickRefreshBlock myblock;
@end
@implementation NoNetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setupWithClickRefresh:(ClickRefreshBlock)block
{
    _myblock = block;
}
- (IBAction)click_refresh:(UIButton *)sender {
    if (self.myblock != nil) {
        self.myblock();
    }
}

@end
