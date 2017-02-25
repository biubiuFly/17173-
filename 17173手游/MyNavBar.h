//
//  MyNavBar.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/3.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyNavBarDelegate <NSObject>

@optional
- (void)click_left;
- (void)click_right;

@end
@interface MyNavBar : UIView
@property (weak, nonatomic) IBOutlet UIButton *btn_left;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_right;
@property (weak, nonatomic) id<MyNavBarDelegate> delegate;
- (void)changeBtn_leftImage;
@end
