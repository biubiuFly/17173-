//
//  NewGame.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/6.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "NewGame.h"
#import "MyNavBar.h"
#import "MyNavViewController.h"
#import "ZXSY.h"
#import "NgController.h"
#import "NoNetView.h"
#import "AppDelegate.h"
@interface NewGame ()<MyNavBarDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)NSMutableArray *arr_btnList;
@property (weak, nonatomic) IBOutlet UIView *btn_bgview;
@property (weak, nonatomic) IBOutlet UIScrollView *sc;
@property (nonatomic, strong) MyNavBar *nav;
@property (nonatomic, strong) NoNetView *nonet;
@end

@implementation NewGame
-(void)viewWillAppear:(BOOL)animated
{
    self.nav.label_title.text = @"新游";
    self.nav.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setNoNetView];
    self.nav = ((MyNavViewController *)self.navigationController).nav;
    self.nav.delegate = self;

    
}

//跳转到这个界面先判断有无网络，无网络展示无网络界面，否则正常加载下级界面
-(void)setNoNetView{
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
        
    }else
    {
        if (self.nonet) {
            [self.nonet removeFromSuperview];
            self.nonet = nil;
        }
        [self setList];
        [self setSc];
    }
}

- (void)setData{
    self.arr_btnList = [NSMutableArray array];
}

//导航栏创建
- (void)setList{
    NSArray *listStr = @[@"最新手游",@"试玩评测",@"福利大观",@"娱乐囧图"];
    for (int i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(80*i, 0, 80, 30);
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
        [self.arr_btnList addObject:btn];
        [self.btn_bgview addSubview:btn];
    }
}

//滚动图添加
- (void)setSc
{
    self.sc.delegate = self;
    self.sc.contentSize = CGSizeMake(320*4, self.sc.bounds.size.height);
    self.sc.pagingEnabled = YES;
    ZXSY *zxsy = [[UIStoryboard storyboardWithName:@"NewGame" bundle:nil] instantiateViewControllerWithIdentifier:@"zxsy"];
    zxsy.view.frame = CGRectMake(0, 0, self.sc.bounds.size.width, self.sc.bounds.size.height);
    [self.sc addSubview:zxsy.view];
    [self addChildViewController:zxsy];
    NSDictionary *head = @{
                           @"User-Agent":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                           @"Content-Type":@"application/json",
                           @"v":@"3.0",
                           @"i":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                           @"c":@"2Ek0x11u1lGuH96av0rUk6MsRi0GXuypaqkvUiYB4rUaszzCX2SM8A==",
                           @"k":@"C1UiqX3x4iy5jhzOEMdyjD6Lr9pjJFltWwCbvH7YWRifC6GgfDmk9M9iJk3nEZP7PlOuxWOxxB1hXW02EQDm/Q=="
                           };

    NSDictionary *head1 = @{
                           @"User-Agent":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                           @"Content-Type":@"application/json",
                           @"v":@"3.0",
                           @"i":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                           @"c":@"51JYCpwp+GU9lOw/CHbJx1NZt1L6tTwUuZTsfOcIm0YNgkjfAobIkg==",
                           @"k":@"K+0gEHEGuDttCrv/RkaGN0OPhmkph1d1WEVT3tF/J1BdqTGBYspAcMpLbLyfomnk4wKNDT7tHEfnt5zQemE5ig=="
                           };
    NSDictionary *head2 = @{
                            @"User-Agent":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                            @"Content-Type":@"application/json",
                            @"v":@"3.0",
                            @"i":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                            @"c":@"aAQl2/WMVzHTKbFtARcKr8Y3vck6+EtJNS1tUZvN8e331tHQIrJDPQ==",
                            @"k":@"mQb5n98q0Rw2aY64SUAEknfyX/AMrd88oQBlAwHX4YsKTkrGp3sjTT7g1ZkcM8iOMAFrnICbJMWXUn7x6CcPWw=="
                            };
    NSArray *arr_head = @[head,head1,head2];
    NSArray *arr_news = @[@"47",@"48",@"172"];

    for (int i = 0; i<3; i++) {
        NgController *ng = [[NgController alloc]init];
        [ng setupWithUrlStr:[NSString stringWithFormat:@"http://a.17173.com/cms/v3/rest/ops/column/%@/news",arr_news[i]] andHeadDict:arr_head[i]];
        ng.view.frame = CGRectMake(320*(i+1), 0, self.sc.bounds.size.width, self.sc.bounds.size.height);
        [self.sc addSubview:ng.view];
        [self addChildViewController:ng];
    }
}
- (void)click_listBtn:(UIButton *)btn{
    for (UIButton *button in self.arr_btnList) {
        button.selected =NO;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    btn.selected = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.sc.contentOffset = CGPointMake(btn.tag*320, 0);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int i = self.sc.contentOffset.x/320;
    for (UIButton *btn in self.arr_btnList) {
        if (btn.tag == i) {
            btn.selected = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
        }else
        {
            btn.selected = NO;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)click_left
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.nav.label_title.text = @"17173手游";
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
