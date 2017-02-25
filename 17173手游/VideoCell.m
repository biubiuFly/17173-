//
//  VideoCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/12.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "VideoCell.h"
#import "UIImageView+WebCache.h"
@interface VideoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image_icon;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UIImageView *image_gameName;
@property (weak, nonatomic) IBOutlet UILabel *label_gameName;
@property (weak, nonatomic) IBOutlet UILabel *label_playedTimes;

@end
@implementation VideoCell
-(void)setupWithModel:(VideoModel *)model{
    [self.image_icon sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.label_title.text   =   model.title;
    NSInteger playedTimes = model.playedTimes.integerValue;
    if (playedTimes>10000) {
        self.label_playedTimes.text = [NSString stringWithFormat:@"%.1f万",playedTimes/10000.0];
    }else{
        self.label_playedTimes.text = [NSString stringWithFormat:@"%ld",playedTimes];
    }
    if (model.gameName.length>0) {
        self.image_gameName.hidden = NO;
        self.label_gameName.hidden = NO;
        CGSize contentMaxSize = CGSizeMake(MAXFLOAT,15);
        NSDictionary *attributesDict = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:9]
                                         };
        CGSize contentRealSize =  [model.gameName boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDict context:nil].size;
        CGRect frame = self.image_gameName.frame;
        self.image_gameName.frame = CGRectMake(frame.origin.x, frame.origin.y, contentRealSize.width+10, 15);
        self.label_gameName.frame = CGRectMake(frame.origin.x, frame.origin.y, contentRealSize.width+5, contentRealSize.height);
        self.label_gameName.text = model.gameName;
    }else
    {
        self.image_gameName.hidden = YES;
        self.label_gameName.hidden = YES;
    }
}
@end
