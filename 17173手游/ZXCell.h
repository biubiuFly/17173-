//
//  ZXCell.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/8.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXModel;
@interface ZXCell : UITableViewCell
- (void)setupWithModel:(ZXModel *)model;
@end
