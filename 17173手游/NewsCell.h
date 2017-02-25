//
//  NewsCell.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/3.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsModel;
@interface NewsCell : UITableViewCell
- (void)setupWithModel:(NewsModel *)model;
@end
