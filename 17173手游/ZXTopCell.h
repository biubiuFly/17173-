//
//  ZXTopCell.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/6.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChaoyueSC.h"
#import "NewsWebViewController.h"
typedef void(^ClickImage)(NewsWebViewController *);
@interface ZXTopCell : UITableViewCell
@property (nonatomic,strong) ClickImage clickBlock;
- (void)setupWithArray:(NSArray *)arr;
@end
