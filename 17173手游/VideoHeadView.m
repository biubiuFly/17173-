//
//  VideoHeadView.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/12.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "VideoHeadView.h"
#import "ChaoyueSC.h"
@implementation VideoHeadView
- (void)setupWithArray:(NSArray *)arr{
    ChaoyueSC * sc = [[ChaoyueSC alloc]initWithFrame:self.frame];
    [sc setupUIwithArr:arr andPageControlFrame:CGRectMake(270, sc.frame.size.height-25, 50, 25) SetTimeInterval:5 KeyInDictWith:@"bigPicUrl" WithImageHeighe:150 TitleKeyInDictWith:@"title" addTapAction:^(NSInteger currentPage) {
        NewsWebViewController * nw = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"newwebview"];
        nw.urlStr = arr[currentPage][@"videoUrl"];

        if (self.tapImage != nil) {
            self.tapImage(nw);
        }
    }];
    [self addSubview:sc];
}
@end
