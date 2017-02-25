//
//  TopCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/3.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "TopCell.h"
#import "MyRootRequest.h"
#import "UIImageView+WebCache.h"


@interface TopCell ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIPageControl *pc;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, strong) NSArray *arr_image;

@end
@implementation TopCell
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
- (void)awakeFromNib {
    [super awakeFromNib];
    

}
- (void)setupWith:(NSArray  *)arr
{
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dict = arr[i];
        NSArray *data = dict[@"data"];
        NSDictionary *dict_data = data[0];
        [arr1 addObject:dict_data];
    }
     ChaoyueSC *sc = [[ChaoyueSC alloc]initWithFrame:CGRectMake(0, 0, 320, 130)];
    [sc setupUIwithArr:arr1 andPageControlFrame:CGRectMake(270, 110, 50, 20) SetTimeInterval:5 KeyInDictWith:@"picUrl" WithImageHeighe:130 addTapAction:^(NSInteger currentPage) {
        NewsWebViewController * nw = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"newwebview"];
        nw.urlStr = arr1[currentPage][@"shouyouUrl"];
        NSLog(@"arr - %@",arr1[currentPage]);
        if (self.clickBlock!=nil) {
            self.clickBlock(nw);
        }
        
    }];
    [self addSubview:sc];

}
- (IBAction)click_newgame:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(click_newgame)]) {
        [self.delegate click_newgame];
    }
}
- (IBAction)click_video:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(click_video)]) {
        [self.delegate click_video];
    }
}
- (IBAction)click_jiongpic:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(click_jiongpic)]) {
        [self.delegate click_jiongpic];
    }
}
- (IBAction)click_activity:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(click_activity)]) {
        [self.delegate click_activity];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
