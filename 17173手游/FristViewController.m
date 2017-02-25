//
//  FristViewController.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/3.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "FristViewController.h"
#import "MyRootRequest.h"
#import "TopCell.h"
#import "HotGameCell.h"
#import "newheader.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "MyNavBar.h"
#import "MyNavViewController.h"
#import "NewsWebViewController.h"
#import "JiongPicViewController.h"
#import "MJRefresh.h"
#import "MJ17173Header.h"
#import "AppDelegate.h"
#import "AlertMonmentView.h"
#import "Reachability.h"
#import "ZXSY.h"
#import "mengmeizi.h"
#import "NewGame.h"
#import "ActivityController.h"
#import "Video.h"
#import "DataManager.h"
@interface FristViewController ()<UITableViewDelegate,UITableViewDataSource,MyNavBarDelegate,TopCellDelegate>
@property (nonatomic , strong) NSArray * arr_top_image;
@property (nonatomic, strong) NSMutableArray *arr_hotgames;
@property (nonatomic, strong) NSMutableArray *arr_newdata;

@property (nonatomic, strong) MyNavBar *nav;
@end

@implementation FristViewController
#define SW [UIScreen mainScreen].bounds.size.width
#define SH [UIScreen mainScreen].bounds.size.height
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav = ((MyNavViewController *)self.navigationController).nav;
    self.nav.delegate = self;
    [self setData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = [MJ17173Header headerWithRefreshingBlock:^{
        [self beginReques];
    }];
    [self beginReques];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    path = [path stringByAppendingPathComponent:@"wy.sqlite"];
    NSLog(@"path - %@",path);
}
//判断有无网络 无网络弹出无网络提示view
- (void)setNoNetAlertView
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isNetWorking == NO) {
        UIView *view = [AlertMonmentView createSubViewWithText:@"哎呀，手机好像没连上网" WithWidth:200 WithHeight:30];
        [self.view addSubview:view];
    }
    
}
//viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [self.nav.btn_left setImage:[UIImage imageNamed:@"appRecom"] forState:UIControlStateNormal];
    [self setNoNetAlertView];
    
}
- (void)setData
{
    self.arr_hotgames = [NSMutableArray array];
    self.arr_newdata = [NSMutableArray array];
}

//网络请求
- (void)beginReques
{
    //请求第一个滚动图的数据
    NSDictionary *header = @{
                             @"User-Agent":@"17173_3.0.0600_A0010101003_8EC21B10EFE09A447309D69FC0CAD1C1BFD975FF(iPhone; iPhone OS 7.1.2)",
                             @"Content-Type":@"application/json"
                             };
    NSDictionary *body = @{
                           @"nums":@"home_focus_AD_0001,home_focus_AD_0002,home_focus_AD_0003,home_focus_AD_0004,home_banner_AD_0004,home_banner_AD_0009",
                           @"version":@"3.3"
                           };
    [MyRootRequest PostUrlWithString:@"http://a.17173.com/cms/v3/rest/adinfo/list" WithHeaderDict:header WithParam:body WithRequestSuccess:^(id object) {
        
        //请求成功将顶部滚动图数据存入数据库
        [[DataManager sharedDataManager]SaveDataToDataBase:object withName:@"topcell"];
        self.arr_top_image = object[@"ad"];
        [self.tableView reloadData];
    } WithRequestFailed:^(NSError *error) {
        
        //请求失败，将上一次存在数据库的数据取出
        NSDictionary *object =[[DataManager sharedDataManager]LoadDatawithName:@"topcell"];
        self.arr_top_image = object[@"ad"];
        [self.tableView reloadData];
    }];
    //请求热门网游TOP10 数据
    [MyRootRequest GetUrlWithString:@"http://mobile.app.shouyou.com/sy/v1/game/topGames" WithRequestSuccess:^(id object) {
        self.arr_hotgames = object[@"data"][@"list"];
        
        //请求成功将顶部滚动图数据存入数据库
        [[DataManager sharedDataManager]SaveDataToDataBase:object withName:@"topgame"];
        [self.tableView reloadData];
    } WithRequestFailed:^(NSError *error) {
        
        //请求失败，将上一次存在数据库的数据取出
        NSDictionary *object = [[DataManager sharedDataManager]LoadDatawithName:@"topgame"];
        self.arr_hotgames = object[@"data"][@"list"];
        [self.tableView reloadData];
        NSLog(@"asdas");
    }];
    //请求今日要闻数据
    NSDictionary *newheader = @{
                                @"User-Agent":@"17173_3.0.0600_A0010101003_8EC21B10EFE09A447309D69FC0CAD1C1BFD975FF(iPhone; iPhone OS 7.1.2)",
                                @"Content-Type":@"application/json",
                                @"v":@"3.0",
                                @"c":@"65rwDlatkQiTagy+gGIIBVHt7WHvWAZEYgPTTrFJBTwcutpJ7uCoVA==",
                                @"k":@"Df+UkYk8DX/T0LAUDjl/MrKD7NT40UMjrZesXIinRAunDEq9dYhsBiZA3AqGjCEdthf48kpXT9d6A3aLcfwriQ=="
                                };
    [MyRootRequest GetUrlWithString:@"http://a.17173.com/cms/v3/rest/cont/todaysNews/list?appRecTs=1480730197" WithHeader:newheader WithRequestSuccess:^(id object) {
        
        //请求成功将顶部滚动图数据存入数据库
        [[DataManager sharedDataManager]SaveDataToDataBase:object withName:@"cell"];
        self.arr_newdata = object[@"result"];
        [self.tableView reloadData];
    } WithRequestFailed:^(NSError *error) {
        
        //请求失败，将上一次存在数据库的数据取出
        NSDictionary *object = [[DataManager sharedDataManager]LoadDatawithName:@"cell"];
        self.arr_newdata = object[@"result"];
        [self.tableView reloadData];
    }];
    [self.tableView.mj_header endRefreshing];
}

//复用cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        NewsWebViewController * nw = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"newwebview"];
        nw.urlStr = self.arr_newdata[indexPath.row][@"newsUrl"];
        nw.webTitle = @"新闻";
        [self.navigationController pushViewController:nw animated:YES];
    }
}

//返回Header高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 ||section == 1) {
        return 0.01;
    }else
    {
        return 13;
    }
}

//返回cellHeader

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        newheader *header = [[[NSBundle mainBundle]loadNibNamed:@"newheader" owner:nil options:nil] lastObject];
        return header;
    }else
    {
        return nil;
    }
}

//返回Footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }else
    {
        return 0.01;
    }
}

//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 220;
    }else if (indexPath.section == 1)
    {
        return 104;
    }else
    {
        return 70;
    }

}

//返回section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

//返回numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else if(section==1)
    {
        return 1;
    }else
    {
        return self.arr_newdata.count;
    }
}
//复用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
            TopCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"TopCell" owner:nil options:nil]lastObject];
                    [cell setupWith:self.arr_top_image];
                    cell.delegate = self;
        cell.clickBlock = ^(NewsWebViewController *nw){
            [self.navigationController pushViewController:nw animated:YES];
        };
                    return cell;
    }else if (indexPath.section == 1)
    {
        HotGameCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HotGameCell" owner:nil options:nil]lastObject];
                [cell setupWithArray:self.arr_hotgames];
        cell.topGameBlock = ^(NSInteger topGame){
            NSLog(@"topgame - %@",self.arr_hotgames[topGame]);
        };
                return cell;
    }else
    {
        static NSString *cellname = @"newcell";
        NewsCell * cell = [tableView dequeueReusableCellWithIdentifier:cellname];
        NewsModel *model = [[NewsModel alloc]initWithDict:self.arr_newdata[indexPath.row]];
        [cell setupWithModel:model];
        return cell;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.nav changeBtn_leftImage];
}

//跳转到囧图界面
- (void)click_jiongpic
{
    JiongPicViewController *jc = [[UIStoryboard storyboardWithName:@"JiongStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"jiong"];
    [self.navigationController pushViewController:jc animated:YES];
}
//跳转到新游界面
- (void)click_newgame
{
    NewGame *ng= [[UIStoryboard storyboardWithName:@"NewGame" bundle:nil] instantiateViewControllerWithIdentifier:@"newgame"];
        [self.navigationController pushViewController:ng animated:YES];
//    ZXSY *zxsy = [[UIStoryboard storyboardWithName:@"NewGame" bundle:nil] instantiateViewControllerWithIdentifier:@"zxsy"];
//    [self.navigationController pushViewController:zxsy animated:YES];
}
//跳转到视频界面
- (void)click_video
{
    Video *vd = [[UIStoryboard storyboardWithName:@"Video" bundle:nil] instantiateViewControllerWithIdentifier:@"video"];
    [self.navigationController pushViewController:vd animated:YES];
}
//跳转到活动界面
- (void)click_activity
{
    ActivityController *ac =[[UIStoryboard storyboardWithName:@"Activity" bundle:nil] instantiateViewControllerWithIdentifier:@"Activity"];
    [self.navigationController pushViewController:ac animated:YES];
}

@end
