//
//  Tactic.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "Tactic.h"
#import "recommend.h"
#import "MyNavBar.h"
#import "MyNavViewController.h"
#import "ZQGL.h"
#import "All.h"
#import "AppDelegate.h"
#import "NoNetView.h"

@interface Tactic ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *btn_bacview;
@property (weak, nonatomic) IBOutlet UIScrollView *sc;
@property (strong,nonatomic) NSMutableArray *arr_btnlist;
@property (nonatomic, strong) NoNetView *nonet;
@property (nonatomic,strong) MyNavBar *nav;
@end

@implementation Tactic
- (void)viewWillAppear:(BOOL)animated
{
    self.nav.label_title.text = @"攻略";
    self.nav.btn_left.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setNoNetView];
    self.nav = ((MyNavViewController *)self.navigationController).nav;
    
}
- (void)setNoNetView{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isNetWorking == NO) {
        if (self.nonet == nil) {
            self.nonet = [[[NSBundle mainBundle]loadNibNamed:@"NoNetView" owner:nil options:nil] objectAtIndex:0];
            self.nonet.center = self.view.center;
            __weak typeof (self) WeakSelf = self;
            [self.nonet setupWithClickRefresh:^{
                [WeakSelf setNoNetView];
            }];
            [self.view addSubview:self.nonet];
        }
    }else{
        if (self.nonet) {
            [self.nonet removeFromSuperview];
            self.nonet = nil;
        }
        [self setSc];
        [self setList];
    }
}
- (void)setData{
    self.arr_btnlist = [NSMutableArray array];
}
- (void)setSc{
    self.sc.contentSize = CGSizeMake(320*3, self.sc.bounds.size.height);
    self.sc.pagingEnabled = YES;
    self.sc.delegate = self;
    
    
    recommend *re = [[UIStoryboard storyboardWithName:@"Tactic" bundle:nil] instantiateViewControllerWithIdentifier:@"tuijian"];
    re.view.frame = CGRectMake(0, 0, self.sc.bounds.size.width, self.sc.bounds.size.height);
    [self.sc addSubview:re.view];
    [self addChildViewController:re];
    
    
    ZQGL *zq = [[UIStoryboard storyboardWithName:@"Tactic" bundle:nil] instantiateViewControllerWithIdentifier:@"zqgl"];
    zq.view.frame = CGRectMake(320, 0, self.sc.bounds.size.width, self.sc.bounds.size.height);
    [self.sc addSubview:zq.view];
    [self addChildViewController:zq];
    All *all = [[UIStoryboard storyboardWithName:@"Tactic" bundle:nil] instantiateViewControllerWithIdentifier:@"all"];
    all.view.frame = CGRectMake(640, 0, self.sc.bounds.size.width, self.sc.bounds.size.height);
    [self.sc addSubview:all.view];
    [self addChildViewController:all];
}
- (void)setList{
    NSArray *listStr = @[@"推荐",@"最强攻略",@"全部"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(1+106*i, 0, 106, 30);
        [btn setTitle:listStr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.tag = i;
        if (i==0) {
            btn.selected = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        [btn addTarget:self action:@selector(click_listBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.arr_btnlist addObject:btn];
        [self.btn_bacview addSubview:btn];
    }
}
- (void)click_listBtn:(UIButton *)btn
{
    for (UIButton *button in self.arr_btnlist) {
        button.selected         = NO;
        button.titleLabel.font  = [UIFont systemFontOfSize:13];
    }
    btn.selected                = YES;
    btn.titleLabel.font         = [UIFont systemFontOfSize:15];
    self.sc.contentOffset       = CGPointMake(320*btn.tag, 0);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int i = self.sc.contentOffset.x/320;
    for (UIButton *btn in self.arr_btnlist) {
        if (btn.tag == i) {
            btn.selected        = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
        }else
        {
            btn.selected        = NO;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.nav.btn_left.hidden = NO;
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
