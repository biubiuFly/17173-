//
//  HotGameCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/3.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "HotGameCell.h"
#import "UIImageView+WebCache.h"
@interface HotGameCell ()
@property (weak, nonatomic) IBOutlet UIScrollView *sc;

@end
@implementation HotGameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupWithArray:(NSArray *)arr
{
    CGFloat width = 50;
    CGFloat height = 50;
    CGFloat space = 10;
    for (int i = 0; i<arr.count; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(space+(space+width)*i, 0, width, height)];
        iv.userInteractionEnabled = YES;
        iv.tag = i;
        iv.layer.masksToBounds = YES;
        NSDictionary *dict =arr[i];
        [iv sd_setImageWithURL:[NSURL URLWithString:dict[@"pic"]]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(icon_tap:)];
        [iv addGestureRecognizer:tap];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(space+(space+width)*i, 55, width, 25)];
        
        lb.textAlignment = NSTextAlignmentCenter;
        lb.numberOfLines = 0;
        lb.font = [UIFont systemFontOfSize:10];
        lb.text = dict[@"gameName"];
        [self.sc addSubview:lb];
        [self.sc addSubview:iv];
    }
    self.sc.contentSize = CGSizeMake((space+width)*arr.count, height);
    self.sc.showsHorizontalScrollIndicator = NO;
}
- (void)icon_tap:(UIGestureRecognizer *)tap
{
    
    if (self.topGameBlock != nil) {
        self.topGameBlock(tap.view.tag);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
