//
//  JiongPicViewController.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/4.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "JiongPicViewController.h"
#import "MyNavBar.h"
#import "MyNavViewController.h"
#import "MyRootRequest.h"
#import "laosiji.h"
#import "GCD.h"
#import "mengmeizi.h"
#import "LoadView.h"
#import "NoNetView.h"
#import "AppDelegate.h"
@interface JiongPicViewController ()<MyNavBarDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *sc_list;
@property (weak, nonatomic) IBOutlet UIScrollView *sc_jiong;
@property (strong, nonatomic) NSMutableArray *arr_list;
@property (assign, nonatomic) NSInteger list_Total;
@property (nonatomic, strong) NSMutableArray *arr_listBtn;
@property (nonatomic, strong) MyNavBar *nav;
@property (nonatomic, strong) NSMutableArray *arr_listID;
@property (nonatomic, strong) NSMutableArray *arr_tvcontroller;

@property (nonatomic, strong) NSMutableArray *arr_sc_views;
@property (nonatomic, strong) NoNetView *nonet;

@end

@implementation JiongPicViewController
#define SW [UIScreen mainScreen].bounds.size.width
#define SH [UIScreen mainScreen].bounds.size.height
- (void)viewDidLoad {

    [super viewDidLoad];
    [self setData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.nav = ((MyNavViewController *)self.navigationController).nav;
    self.nav.delegate = self;
    self.sc_jiong.delegate = self;

    [self setNoNetView];

    [self beginreques];

}
-(void)setNoNetView{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isNetWorking == NO) {
        if (self.nonet == nil) {
            self.nonet = [[[NSBundle mainBundle]loadNibNamed:@"NoNetView" owner:nil options:nil] objectAtIndex:0];
            self.nonet.center = self.view.center;
            __weak typeof (self) WeakSelf = self;
            [self.nonet setupWithClickRefresh:^{
                [WeakSelf beginreques];
            }];
            [self.view addSubview:self.nonet];
        }
        
    }else
    {
        if (self.nonet) {
            [self.nonet removeFromSuperview];
            self.nonet = nil;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    self.nav.label_title.text = @"内涵囧图";
    self.nav.delegate = self;
}
- (void)setJiongSC:(NSArray *)Section
{
    self.sc_jiong.contentSize = CGSizeMake(SW*Section.count, self.sc_jiong.frame.size.height);
    self.sc_jiong.showsHorizontalScrollIndicator = NO;
    self.sc_jiong.pagingEnabled = YES;
    
    for (int i = 0; i<Section.count; i++) {
        mengmeizi *mm = [[UIStoryboard storyboardWithName:@"JiongStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"mengmeizi"];
        mm.view.frame = CGRectMake(SW*i, 0, SW, SH-64-49-30);
        [mm setupWithSection:Section[i]];
        [self.sc_jiong addSubview:mm.view];
        [self addChildViewController:mm];
    }
}
- (void)setData
{
    self.arr_list = [NSMutableArray array];
    self.list_Total = 1;
    self.arr_listBtn = [NSMutableArray array];
    self.arr_listID = [NSMutableArray array];
    self.arr_tvcontroller = [NSMutableArray array];
    self.arr_sc_views = [NSMutableArray array];
}
- (void)beginreques
{
    //获取列表数据
    NSDictionary *listHeader = @{
                                 @"User-Agent":@"17173_3.4.0100_A0017025221_9474af11",
                                 @"v":@"3.0",
                                 @"i":@"17173_3.4.0100_A0017025221_9474af11",
                                 @"c":@"lOHX/8cHbJG6iK/B0tofStmhXHov7NqCa/11Rml2UAappfN0lqt3qw==",
                                 @"Content-Type":@"application/json",
                                 @"k":@"m/0becd1WUCbKSP3wJVo/BHYfUTHgeomUSfMHikP1M7PYcSNhx9mPAlyr2ArqNZmA9GTfMirseQbyzU5qrOXqA=="
                                 };
    [MyRootRequest GetUrlWithString:@"http://a.17173.com/api/section/list?platCode=ANDROID&pageSize=-1" WithHeader:listHeader WithRequestSuccess:^(id object) {
        [self.nonet removeFromSuperview];
        self.nonet = nil;
        NSNumber *num =object[@"Data"][@"Total"];
        self.list_Total = num.integerValue;
        self.arr_list = object[@"Data"][@"List"];
        for (NSDictionary *dict in self.arr_list) {
            NSString *ID = [NSString stringWithFormat:@"%@",dict[@"ID"]];
            [self.arr_listID addObject:ID];
        }

        [self setJiongSC:self.arr_listID];
        [self setlist];
 
    } WithRequestFailed:^(NSError *error) {
        
    }];
}
- (void)setlist
{
    CGFloat list_width = SW/5;
    //设置UIScrollView
    self.sc_list.contentSize = CGSizeMake(SW+list_width, 30);
        
    self.sc_list.bounces = NO;
    self.sc_list.showsHorizontalScrollIndicator = NO;
    //往UIScrollView添加list
    for (int i = 0; i<self.list_Total; i++) {
        UIButton * btn_list = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_list.frame = CGRectMake(list_width*i, 0, list_width, 30);
        [btn_list setTitle:self.arr_list[i][@"Title"] forState:UIControlStateNormal];
        [btn_list setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_list setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        btn_list.titleLabel.font = [UIFont systemFontOfSize:13];
        btn_list.tag = i;
        [btn_list addTarget:self action:@selector(click_list:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn_list.selected = YES;
            btn_list.titleLabel.font = [UIFont systemFontOfSize:18];
        }
        [self.arr_listBtn addObject:btn_list];
        [self.sc_list addSubview:btn_list];
    }
}

- (void)click_list:(UIButton *)btn
{
    for (int i = 0; i<self.arr_listBtn.count; i++) {
        UIButton *button = self.arr_listBtn[i];
        if (i==btn.tag) {

            [GCDQueue executeInMainQueue:^{
                button.selected = YES;
                button.titleLabel.font = [UIFont systemFontOfSize:18];
            }];
            self.sc_jiong.contentOffset = CGPointMake(btn.tag*SW, 0);
        }else
        {
            button.selected = NO;
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            
        }
        
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int i = self.sc_jiong.contentOffset.x/SW;
    if (i == 5) {
        self.sc_list.contentOffset = CGPointMake(SW/5, 0);
    }
    if (i==0) {
        self.sc_list.contentOffset = CGPointMake(0, 0);
    }
    for (int j = 0; j<self.arr_listBtn.count; j++) {
        UIButton *btn = self.arr_listBtn[j];
        if (j==i) {
            btn.selected = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:18];
        }else{
            btn.selected = NO;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
        }
    }
}
- (void)click_left
{
    [self.navigationController popViewControllerAnimated:YES];
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
-(void)viewWillDisappear:(BOOL)animated
{
    self.nav.label_title.text = @"17173手游";
}
@end
