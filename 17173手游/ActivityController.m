//
//  ActivityController.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/9.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "ActivityController.h"
#import "MJRefresh.h"
#import "MJ17173Footer.h"
#import "MJ17173Header.h"
#import "MyRootRequest.h"
#import "ActivityCell.h"
#import "ActivityModel.h"
#import "NewsWebViewController.h"
#import "MyNavBar.h"
#import "MyNavViewController.h"
#import "NoNetView.h"
#import "AppDelegate.h"
#import "AlertMonmentView.h"
@interface ActivityController ()<UITableViewDelegate,UITableViewDataSource,MyNavBarDelegate>
@property (nonatomic,strong)NSMutableDictionary *dict_body;
@property (nonatomic,strong)NSMutableArray *arr_data;
@property (nonatomic, strong) MyNavBar *nav;
@property (nonatomic)NSInteger pageNo;
@property (nonatomic)NSInteger totalPage;
@property (nonatomic, strong) NoNetView *nonet;
@end

@implementation ActivityController

-(void)viewWillAppear:(BOOL)animated
{
    self.nav.label_title.text = @"活动";
    self.nav.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav = ((MyNavViewController *)self.navigationController).nav;
    self.nav.delegate = self;
    [self setData];
    [self setTv];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (app.isNetWorking == NO) {
        
        if (self.nonet == nil) {
            self.nonet = [[[NSBundle mainBundle]loadNibNamed:@"NoNetView" owner:nil options:nil] objectAtIndex:0];
            self.nonet.center = self.tableView.center;
            
            __weak typeof (self) WeakSelf = self;
            [self.nonet setupWithClickRefresh:^{
                [WeakSelf viewDidLoad];
            }];
            
            [self.tableView addSubview:self.nonet];
        }
        
    }else
    {
        if (self.nonet) {
            [self.nonet removeFromSuperview];
            self.nonet = nil;
        }
    }

    [self beginReques];
}
- (void)setData{
    self.dict_body = [@{
                       @"activityStatus": @[
                                          @"VISIABLE",
                                          @"RUNNING",
                                          @"END"],
                       @"activityType": @[
                                        @"ADVERTISEMENT",
                                        @"GIFTS",
                                        @"APPLICATION"],
                       @"pageSize": @"10",
                       @"pageNo": @"1"
                       } mutableCopy];
    self.arr_data = [NSMutableArray array];
}
- (void)setTv
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = [MJ17173Header headerWithRefreshingBlock:^{
        self.dict_body = [@{
                            @"activityStatus": @[
                                    @"VISIABLE",
                                    @"RUNNING",
                                    @"END"],
                            @"activityType": @[
                                    @"ADVERTISEMENT",
                                    @"GIFTS",
                                    @"APPLICATION"],
                            @"pageSize": @"10",
                            @"pageNo": @"1"
                            } mutableCopy];
        [self setNoNetAlertView];
        [self beginReques];
    }];
    self.tableView.mj_footer = [MJ17173Footer footerWithRefreshingBlock:^{
        [self beginReques];
    }];

}
- (void)setNoNetAlertView
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isNetWorking == NO) {
        UIView *view = [AlertMonmentView createSubViewWithText:@"哎呀，手机好像没连上网" WithWidth:200 WithHeight:30];
        view.frame = CGRectMake(80, [UIScreen mainScreen].bounds.size.height-60-64-60, 200, 30);
        
        [self.view addSubview:view];
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.arr_data removeAllObjects];
        
    }
    
}

- (void)beginReques{
   
    NSDictionary *header = @{
                             @"User-Agent":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                             @"Content-Type":@"application/json",
                             @"v":@"3.0",
                             @"i":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                             @"c":@"uPhJRN6jDvYZ5ESxcmMtIAEQ/wq8bofMqauOquDQ2trQVHBuQdNwvA==",
                             @"k":@"aWUKWcmOByyu3Q5xjFRND8idPIzJE9rXrHGgPlr0SS4TGnM84vy04lAUljpM9aXVy1lzJPsLMcjHRm4UEAtSQQ=="
                             
                             };
    [MyRootRequest PostUrlWithString:@"http://a.17173.com/cms/v3/rest/cont/activity/list" WithHeaderDict:header WithParam:self.dict_body WithRequestSuccess:^(id object) {
        NSArray *list = object[@"datas"][@"list"];
        NSNumber *page = object[@"datas"][@"pageNo"];
        NSNumber *pages = object[@"datas"][@"totalPage"];
        self.pageNo =page.integerValue;
        self.totalPage = pages.integerValue;
        if (self.pageNo == self.totalPage) {
            [self.tableView.mj_footer removeFromSuperview];
        }
        [self.arr_data addObjectsFromArray:list];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.dict_body setValue:[NSString stringWithFormat:@"%ld",self.pageNo+1] forKey:@"pageNo"];
    } WithRequestFailed:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arr_data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellname = @"activity";
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    ActivityModel *model = [[ActivityModel alloc]initWithDict:self.arr_data[indexPath.row]];
    [cell setupWithModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 208;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsWebViewController * nw = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"newwebview"];
    nw.urlStr = self.arr_data[indexPath.row][@"htmlUrl"];
    nw.webTitle = @"活动详情";
    [self.navigationController pushViewController:nw animated:YES];
    
}
- (void)click_left
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.nav.label_title.text = @"17173手游";
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
