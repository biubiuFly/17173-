//
//  NgCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/8.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "NgCell.h"
#import "UIImageView+WebCache.h"
#import "NgModel.h"
@interface NgCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image_icon;
@property (weak, nonatomic) IBOutlet UILabel *label_title;

@end
@implementation NgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupWithModel:(NgModel *)model
{
    [self.image_icon sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"gamedetail_logo_placeholder"]];
    self.label_title.text = model.title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
