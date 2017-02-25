//
//  TopCell.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/3.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsWebViewController.h"
#import "ChaoyueSC.h"

typedef void(^ClickImage)(NewsWebViewController *);
@protocol TopCellDelegate <NSObject>
@optional
- (void)click_newgame;
- (void)click_video;
- (void)click_jiongpic;
- (void)click_activity;

@end
@interface TopCell : UITableViewCell
@property (nonatomic,strong) ClickImage clickBlock;
@property (weak, nonatomic) id<TopCellDelegate> delegate;
- (void)setupWith:(NSArray *)arr;
@end
