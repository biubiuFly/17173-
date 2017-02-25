//
//  ZXTopCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/6.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "ZXTopCell.h"

@implementation ZXTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupWithArray:(NSArray *)arr
{
    ChaoyueSC *sc = [[ChaoyueSC alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    [sc setupUIwithArr:arr andPageControlFrame:CGRectMake(270, self.frame.size.height-25, 50, 25) SetTimeInterval:5 KeyInDictWith:@"bigPicUrl" WithImageHeighe:150 TitleKeyInDictWith:@"title" addTapAction:^(NSInteger currentPage) {
        NewsWebViewController * nw = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"newwebview"];
        nw.urlStr = arr[currentPage][@"newsUrl"];
        if (self.clickBlock!=nil) {
            self.clickBlock(nw);
        }
    }];
    [self addSubview:sc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
