//
//  VideoHeadView.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/12.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsWebViewController.h"
typedef void(^ClickHeadImage)(NewsWebViewController *);
@interface VideoHeadView : UICollectionReusableView
@property (nonatomic,strong)ClickHeadImage tapImage;
- (void)setupWithArray:(NSArray *)arr;
@end
