//
//  glxjhead.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "glxjhead.h"
#import "ChaoyueSC.h"
@implementation glxjhead

- (void)setupWithArray:(NSArray *)arr andStrategy:(NSDictionary *)dict
{
    ChaoyueSC *sc = [[ChaoyueSC alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 150)];
    [sc setupUIwithArr:arr andPageControlFrame:CGRectMake(220, sc.frame.size.height-25, 100, 25) SetTimeInterval:5 KeyInDictWith:@"picUrl" WithImageHeighe:150 TitleKeyInDictWith:@"description" addTapAction:^(NSInteger currentPage) {
        
    }];
    [self addSubview:sc];
    [self bringSubviewToFront:self.view_back];
    self.label_sort.text = [NSString stringWithFormat:@"排名 %@",dict[@"sort"]];
    NSNumber *count = dict[@"externalSub"];
    NSInteger num = count.integerValue;
    if (num>10000) {
        self.label_externalSub.text = [NSString stringWithFormat:@"订阅 %ld万",num/10000];
    }else
    {
        self.label_externalSub.text = [NSString stringWithFormat:@"订阅 %ld",num];
    }
}
@end
