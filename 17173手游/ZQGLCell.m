//
//  ZQGLCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "ZQGLCell.h"
#import "UIImageView+WebCache.h"
@interface ZQGLCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image_icon;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_introduce;
@property (weak, nonatomic) IBOutlet UILabel *label_version;

@end
@implementation ZQGLCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupWithModel:(ZQGLModel *)model
{
    [self.image_icon sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    self.label_name.text        = model.namezq;
    self.label_introduce.text   = model.introduce;
    self.label_version.text     = [NSString stringWithFormat:@"版本号：%@",model.itunesVersion];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
