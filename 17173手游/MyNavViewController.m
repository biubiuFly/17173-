//
//  MyNavViewController.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/3.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "MyNavViewController.h"

@interface MyNavViewController ()

@end

@implementation MyNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.hidden = YES;
    self.nav = [[[NSBundle mainBundle]loadNibNamed:@"MyNavBar" owner:nil options:nil] objectAtIndex:0];
    self.nav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    [self.view addSubview:self.nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
