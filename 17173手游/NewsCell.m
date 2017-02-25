//
//  NewsCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/3.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "NewsCell.h"
#import "NewsModel.h"
#import "UIImageView+WebCache.h"
@interface NewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image_pic;
@property (weak, nonatomic) IBOutlet UILabel *label_title;


@end
@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupWithModel:(NewsModel *)model
{
    [self.image_pic sd_setImageWithURL:[NSURL URLWithString:model.picUrl]placeholderImage:[UIImage imageNamed:@"gamedetail_logo_placeholder"]];
    
    self.label_title.text = model.title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
