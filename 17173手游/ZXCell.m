//
//  ZXCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/8.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "ZXCell.h"
#import "ZXModel.h"
#import "UIImageView+WebCache.h"
@interface ZXCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image_icon;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UIImageView *image_video;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_left;

@end
@implementation ZXCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupWithModel:(ZXModel *)model{
    self.image_icon.layer.masksToBounds = YES;
    self.image_icon.layer.cornerRadius = 10;
    if (![model.contentVpicList isEqualToString:@""]) {
        self.image_video.hidden = NO;
        self.image_icon.hidden = NO;
        self.icon_left.constant = 78;
        self.title_left.constant = 73;
        NSString *str = [model.contentVpicList stringByReplacingOccurrencesOfString:@"[" withString:@""];
        NSString *str1 = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSArray *arr = [str1 componentsSeparatedByString:@","];
        NSString *str2 = arr[0];
        NSRange rang = NSMakeRange(1, str2.length - 2);
        NSString *imageUrl = [str2 substringWithRange:rang];
        [self.image_icon sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }else if(![model.picUrl isEqualToString:@""]){
        self.image_video.hidden = YES;
        self.image_icon.hidden = NO;
        self.icon_left.constant = 78;
        self.title_left.constant = 73;
    [self.image_icon sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"gamedetail_logo_placeholder"]];
    }else
    {
        self.image_video.hidden = YES;
        self.image_icon.hidden = YES;
        self.icon_left.constant = 8;
        self.title_left.constant = 3;
    }
    self.label_title.text = model.title;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
