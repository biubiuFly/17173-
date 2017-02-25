//
//  ZXSY.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/6.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "ZXSY.h"
#import "ZXTopCell.h"
#import "MyRootRequest.h"
#import "ZXCell.h"
#import "ZXModel.h"
#import "MJRefresh.h"
#import "MJ17173Footer.h"
#import "MJ17173Header.h"
#import "NewsWebViewController.h"
#import "AppDelegate.h"
#import "AlertMonmentView.h"
@interface ZXSY ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (nonatomic, strong) NSMutableArray *arr_topcelldata;
@property (nonatomic, strong) NSMutableDictionary *body;
@property (nonatomic)NSInteger page;
@end

@implementation ZXSY

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setTV];
    [self beginReques];
}
- (void)setData
{
    self.arr_data = [NSMutableArray array];
    self.arr_topcelldata = [NSMutableArray array];
   self.body = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"size":@"20",
                                                                                @"menu":@"0",
                                                                                @"page":@"1",
                                                                                @"orderts":@"0"
                                                                                } ];
}
- (void)setTV
{
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.mj_header = [MJ17173Header headerWithRefreshingBlock:^{
        NSDictionary *dd = @{
                             @"size":@"20",
                             @"menu":@"0",
                             @"page":@"1",
                             @"orderts":@"0"
                             };
        self.body =[NSMutableDictionary dictionaryWithDictionary:dd];
        [self setNoNetAlertView];
        [self beginReques];
    }];
    self.tv.mj_footer = [MJ17173Footer footerWithRefreshingBlock:^{
        [self beginReques];
    }];
}

//无网络提示框
- (void)setNoNetAlertView
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isNetWorking == NO) {
        UIView *view = [AlertMonmentView createSubViewWithText:@"哎呀，手机好像没连上网" WithWidth:200 WithHeight:30];
        view.frame = CGRectMake(80, [UIScreen mainScreen].bounds.size.height-60-64-60, 200, 30);
        
        [self.view addSubview:view];
        [self.tv.mj_header endRefreshing];
    }else{
        [self.arr_data removeAllObjects];
    }
    
}

//网络请求
- (void)beginReques
{
    NSDictionary *head = @{
                           @"User-Agent":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09",
                           @"Content-Type":@"application/json",
                           @"v":@"3.0",
                           @"i":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                           @"c":@"OkFAkCbkue/zVLjU1N162AE5FPX1E5NO8H7dMo5D0XUj3Bej0MbBwA==",
                           @"k":@"jevZ52x/zLsVg+Weka7U0cE4CCscKo4nMGdou8BLAoHiHVVSrsnY/xh7zIMhm9FQ5/4DKVweZ/gqMpzvBwfnRw=="
                           };
    [MyRootRequest PostUrlWithString:@"http://a.17173.com/cms/v3/rest/ops/column/23/news" WithHeaderDict:head WithParam:self.body WithRequestSuccess:^(id object) {
        NSArray *arr =  object[@"result"][@"content"];
        NSNumber *p =object[@"result"][@"curPage"];
        self.page = p.integerValue;
        NSString *orderts =self.body[@"orderts"];
        NSLog(@"orderts - %@",orderts);
//        if ([orderts isEqualToString:@"0"]) {
//            [self.arr_data removeAllObjects];
//        }
        
        [self.arr_data addObjectsFromArray:arr];
        for (int i = 0; i<3; i++) {
            NSDictionary *dict = self.arr_data[i];
            [self.arr_topcelldata addObject:dict];
        }
        [self.tv reloadData];
        [self.tv.mj_header endRefreshing];
        [self.tv.mj_footer endRefreshing];
        NSDictionary *d = [arr lastObject];
        [self.body setValue:[NSString stringWithFormat:@"%ld",self.page+1] forKey:@"page"];
        [self.body setValue:d[@"orderts"] forKey:@"orderts"];
    } WithRequestFailed:^(NSError *error) {
        
    }];
}

//点击cell跳转cell下级界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row>=1) {
        NewsWebViewController * nw = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"newwebview"];
        nw.urlStr = self.arr_data[indexPath.row+2][@"newsUrl"];
        [self.navigationController pushViewController:nw animated:YES];
    }
    
    
}

//numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr_data.count-2;
}
//heightForRowAtIndexPath
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 150;
    }else
    {
        return 80;
    }
}

//复用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ZXTopCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ZXTopCell" owner:nil options:nil] lastObject];
        [cell setupWithArray:self.arr_topcelldata];
        cell.clickBlock = ^(NewsWebViewController *nw){
            [self.navigationController pushViewController:nw animated:YES];
        };
        return cell;
    }else
    {
        static NSString *cellname = @"zxsy";
        ZXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
        ZXModel *model = [[ZXModel alloc]initWithDict:self.arr_data[indexPath.row+2]];
        [cell setupWithModel:model];
        return cell;
    }
}
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

@end
