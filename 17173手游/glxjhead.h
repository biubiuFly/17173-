//
//  glxjhead.h
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface glxjhead : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *label_externalSub;
@property (weak, nonatomic) IBOutlet UILabel *label_sort;
@property (weak, nonatomic) IBOutlet UIView *view_back;
- (void)setupWithArray:(NSArray *)arr andStrategy:(NSDictionary *)dict;
@end
