//
//  NewsWebViewController.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/3.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "NewsWebViewController.h"
#import "MyNavBar.h"
#import "MyNavViewController.h"
#import "AppDelegate.h"
#import "NoNetView.h"
@interface NewsWebViewController ()<UIWebViewDelegate,MyNavBarDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *wv;
@property (nonatomic, strong) MyNavBar *nav;
@property (weak, nonatomic) IBOutlet UIView *pinglun_view;
@property (nonatomic, strong) NoNetView *nonet;
@end

@implementation NewsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.nav = ((MyNavViewController *)self.navigationController).nav;
    self.nav.delegate = self;

    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setWebVIew];
}
- (void)viewWillAppear:(BOOL)animated
{
    if (self.webTitle ==nil) {
        self.nav.label_title.text = @"新闻";
    }else{
        self.nav.label_title.text = self.webTitle;
    }
}
- (void)setWebVIew
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isNetWorking == NO) {
        self.wv.hidden = YES;
        self.pinglun_view.hidden = YES;
        if (self.nonet == nil) {
            self.nonet = [[[NSBundle mainBundle]loadNibNamed:@"NoNetView" owner:nil options:nil] objectAtIndex:0];
            self.nonet.center = self.view.center;
            __weak typeof (self) WeakSelf = self;
            [self.nonet setupWithClickRefresh:^{
                [WeakSelf setWebVIew];
            }];
            [self.view addSubview:self.nonet];
        }

    }else
    {
        self.wv.hidden = NO;
        self.pinglun_view.hidden = NO;
        if (self.nonet) {
            [self.nonet removeFromSuperview];
            self.nonet = nil;
        }
          [self.wv sizeToFit];
            self.wv.delegate = self;
            [self.wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
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
-(void)viewWillDisappear:(BOOL)animated
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
