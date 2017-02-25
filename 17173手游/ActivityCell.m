//
//  ActivityCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/9.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "ActivityCell.h"
#import "ActivityModel.h"
#import "UIImageView+WebCache.h"
@interface ActivityCell()
@property (weak, nonatomic) IBOutlet UIImageView *image_icon;
@property (weak, nonatomic) IBOutlet UILabel *label_title;

@property (weak, nonatomic) IBOutlet UIImageView *image_activitying;
@property (weak, nonatomic) IBOutlet UIImageView *image_huodong;
@property (weak, nonatomic) IBOutlet UILabel *label_time;


@end
@implementation ActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
- (void)setupWithModel:(ActivityModel *)model
{
    [self.image_icon sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    self.label_title.text = model.introduction;
    CGFloat time =  [[NSDate date]timeIntervalSince1970];
    if (model.endTime.doubleValue>time*1000) {
        self.image_activitying.image = [UIImage imageNamed:@"huodong_jinxingzhong_btn"];
        self.image_huodong.image = [UIImage imageNamed:@"huodong_jinxingzhong_line"];
    }else{
        self.image_activitying.image = [UIImage imageNamed:@"huodong_yijieshu_btn"];
        self.image_huodong.image = [UIImage imageNamed:@"huodong_other_line"];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:model.startTime.doubleValue/1000.0];
    NSString *startTime = [dateFormatter stringFromDate:startDate];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:model.endTime.doubleValue/1000.0];
    NSString *endTime = [dateFormatter stringFromDate:endDate];
    self.label_time.text = [NSString stringWithFormat:@"%@—%@",startTime,endTime];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
