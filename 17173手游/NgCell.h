//
//  NgCell.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/8.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NgModel;
@interface NgCell : UITableViewCell
- (void)setupWithModel:(NgModel *)model;
@end
