//
//  LaosijiCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/4.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "LaosijiCell.h"
#import "UIImageView+WebCache.h"
#import "LaosijiModel.h"
@interface LaosijiCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image_icon;
@property (weak, nonatomic) IBOutlet UILabel *label_Title;
@property (weak, nonatomic) IBOutlet UILabel *label_count;

@end
@implementation LaosijiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupWithModel:(LaosijiModel *)model
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
