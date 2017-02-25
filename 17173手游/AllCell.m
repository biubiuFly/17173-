//
//  AllCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "AllCell.h"
#import "UIImageView+WebCache.h"
@interface AllCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image_icon;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_introduce;
@property (weak, nonatomic) IBOutlet UILabel *label_dingyuecount;

@end
@implementation AllCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupWithModel:(AllModel *)model{
    [self.image_icon sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    self.label_name.text            =   model.name;
    self.label_introduce.text       =   model.introduce;
    self.label_dingyuecount.text    =   [NSString stringWithFormat:@"%@人订阅",model.dingyuecount];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
