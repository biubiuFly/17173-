//
//  MengmeiziCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/5.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "MengmeiziCell.h"
#import "MengmeiziModel.h"
#import "UIImageView+WebCache.h"
@interface MengmeiziCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image_icon;
@property (weak, nonatomic) IBOutlet UILabel *label_Title;
@property (weak, nonatomic) IBOutlet UILabel *label_count;

@end
@implementation MengmeiziCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupWithModel:(MengmeiziModel *)model
{
    [self.image_icon sd_setImageWithURL:[NSURL URLWithString:model.MiddleCover]];
    self.label_count.text = [NSString stringWithFormat:@"%@",model.Count];
    self.label_Title.text = model.Title;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
