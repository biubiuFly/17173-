//
//  glxjCell.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "glxjCell.h"
#import "UIImageView+WebCache.h"
@interface glxjCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image_icon;
@property (weak, nonatomic) IBOutlet UILabel *label_name;

@end
@implementation glxjCell
- (void)setupWithModel:(glxjModel *)model
{
    [self.image_icon sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"sy_game_list_placeholder_image"]];
    self.label_name.text = model.name;
}
@end
