//
//  NoNetView.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/6.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickRefreshBlock)();
@interface NoNetView : UIView
- (void)setupWithClickRefresh:(ClickRefreshBlock)block;
@end
