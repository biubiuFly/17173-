//
//  ActivityCell.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/9.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityModel;
@interface ActivityCell : UITableViewCell

- (void)setupWithModel:(ActivityModel *)model;
@end
