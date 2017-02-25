//
//  Video.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "Video.h"
#import "MyNavBar.h"
#import "MyNavViewController.h"
#import "MyRootRequest.h"
#import "VideoCV.h"
#import "NoNetView.h"
#import "AppDelegate.h"

@interface Video ()<MyNavBarDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *sc;
@property (weak, nonatomic) IBOutlet UIView *btn_bacview;
@property (nonatomic, strong) MyNavBar *nav;
@property (nonatomic,strong) NSMutableArray *arr_listBtn;
@property (nonatomic, strong) NoNetView *nonet;
@end
#define SW [UIScreen mainScreen].bounds.size.width

@implementation Video
- (void)viewWillAppear:(BOOL)animated
{
    self.nav.label_title.text = @"视频";
    self.nav.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setNoNetView];
    self.nav = ((MyNavViewController *)self.navigationController).nav;
    self.nav.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
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
    self.arr_listBtn = [NSMutableArray array];
}
- (void)setList{
    NSArray *arr_listTitle = @[@"头条",@"原创栏目",@"试玩评测",@"新手游"];
    for (int i = 0; i<arr_listTitle.count; i++) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width/arr_listTitle.count;
        UIButton *btn_list = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_list.frame = CGRectMake(i*width, 0, width,30);
        [btn_list setTitle:arr_listTitle[i] forState:UIControlStateNormal];
        [btn_list setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_list setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        btn_list.tag = i;
        [btn_list addTarget:self action:@selector(click_listBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn_list.titleLabel.font = [UIFont systemFontOfSize:13];
        if (i==0) {
            btn_list.selected = YES;
            btn_list.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        [self.arr_listBtn addObject:btn_list];
        [self.btn_bacview addSubview:btn_list];
    }
}
- (void)click_listBtn:(UIButton *)btn{
    for (UIButton *button in self.arr_listBtn) {
        button.selected = NO;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    btn.selected = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.sc.contentOffset = CGPointMake(SW*btn.tag, 0);
}
- (void)setSc{

    self.sc.delegate = self;
    self.sc.pagingEnabled = YES;
    
    //立即重新构建整个页面的frame
    [self.view layoutIfNeeded];
    
    self.sc.contentSize = CGSizeMake(SW*4,self.sc.bounds.size.height);
 
    
    NSArray *arr_id = @[@"305",@"312",@"316",@"317"];
    for (int i = 0; i<arr_id.count; i++) {
        VideoCV *vcv = [[UIStoryboard storyboardWithName:@"Video" bundle:nil] instantiateViewControllerWithIdentifier:@"videocv"];
        [vcv setupWithVideoID:arr_id[i]];
        vcv.view.frame = CGRectMake(SW*i, 0, self.sc.bounds.size.width, self.sc.bounds.size.height);
        [self.sc addSubview:vcv.view];
        [self addChildViewController:vcv];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int i = self.sc.contentOffset.x/320;
    for (UIButton *btn in self.arr_listBtn) {
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
//-(void)beginReques{
//    [MyRootRequest PostUrlWithString:<#(NSString *)#> WithHeaderDict:<#(NSDictionary *)#> WithParam:<#(NSDictionary *)#> WithRequestSuccess:<#^(id object)sucessBlock#> WithRequestFailed:<#^(NSError *error)failedBlock#>]
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)click_left{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.nav.label_title.text = @"17173手游";
}
@end
