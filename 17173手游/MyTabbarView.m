//
//  MyTabbarView.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/3.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "MyTabbarView.h"

@interface MyTabbarView ()
@property (nonatomic, strong) NSMutableArray *arr_btn;
@end

@implementation MyTabbarView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.hidden = YES;
    
    self.arr_btn = [NSMutableArray array];
    [self setupTabbar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupTabbar
{
    CGFloat SW = [UIScreen mainScreen].bounds.size.width;
    CGFloat SH = [UIScreen mainScreen].bounds.size.height;
    UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(0, SH-49, SW, 49)];
    iv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:iv];
    NSArray *arr_tabbar_image_h = @[@"tabbar_head_h",@"tabbar_gl_h",@"tabbar_my_h"];
    NSArray *arr_tabbar_image_n = @[@"tabbar_head_n",@"tabbar_gl_n",@"tabbar_my_n"];
    for (int i = 0 ; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat space = (SW-27*3)/3;
        btn.frame = CGRectMake((space+27)*i+space/2, 0, 27, 49);
        [btn setImage:[UIImage imageNamed:arr_tabbar_image_n[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:arr_tabbar_image_h[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        if (i==0) {
            btn.selected = YES;
        }
        [self.arr_btn addObject:btn];
        [iv addSubview:btn];
    }

    
    
}
- (void)clickBtn:(UIButton *)btn
{
    
    for (int i = 0; i<3; i++) {
        UIButton *button = self.arr_btn[i];
        if (i==btn.tag) {
            button.selected = YES;
        }else
        {
            button.selected = NO;
        }
        
    }
    self.selectedIndex = btn.tag;
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
