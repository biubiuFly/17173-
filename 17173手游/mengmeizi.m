//
//  mengmeizi.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/5.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "mengmeizi.h"
#import "MyRootRequest.h"
#import "MengmeiziCell.h"
#import "MengmeiziModel.h"
#import "JiongViewController.h"
#import "MJRefresh.h"
#import "MJ17173Footer.h"
#import "MJ17173Header.h"
#import "LoadView.h"
#import "NoNetView.h"
#import "AppDelegate.h"
#import "AlertMonmentView.h"
@interface mengmeizi ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (nonatomic, strong) NSString *urlStr;
@property (strong, nonatomic) NSString *cellStr;
@property (strong, nonatomic) NSMutableArray *arr_cellurl;
@property (nonatomic) NSInteger PublicDate;
@property (nonatomic, strong) NSString *Section;
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (nonatomic, strong) NoNetView *nonet;
@property (nonatomic, strong) LoadView *lv;
@end

@implementation mengmeizi

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setTv];
    self.lv = [[[NSBundle mainBundle]loadNibNamed:@"LoadView" owner:nil options:nil]lastObject];
    self.lv.center = self.view.center;
    [self.view addSubview:self.lv];
    }
- (void)setData
{
    self.arr_data = [NSMutableArray array];
    self.arr_cellurl = [NSMutableArray array];

}
- (void)setTv
{
    self.tv.delegate =self;
    self.tv.dataSource = self;
    self.tv.mj_header = [MJ17173Header headerWithRefreshingBlock:^{
         self.urlStr = [NSString stringWithFormat:@"http://a.17173.com/api/photos/list?platCode=IOS&maxPublicDate=0&pageSize=10&sections=%@",self.Section];
        [self beginReques];
        [self setNoNetAlertView];
    }];
    self.tv.mj_footer = [MJ17173Footer footerWithRefreshingBlock:^{
        [self beginReques];
        [self setNoNetAlertView];
    }];
}

- (void)setupWithSection:(NSString *)section
{
    self.PublicDate = 0;
    self.Section = section;
    self.urlStr = [NSString stringWithFormat:@"http://a.17173.com/api/photos/list?platCode=IOS&maxPublicDate=%ld&pageSize=10&sections=%@",(long)self.PublicDate,section];
    [self beginReques];
}
- (void)setNoNetAlertView
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isNetWorking == NO) {
        UIView *view = [AlertMonmentView createSubViewWithText:@"哎呀，手机好像没连上网" WithWidth:200 WithHeight:30];
        view.frame = CGRectMake(80, [UIScreen mainScreen].bounds.size.height-60-64-60, 200, 30);
        
        [self.view addSubview:view];
    }
    [self.tv.mj_header endRefreshing];
}

- (void)beginReques
{
    [self.lv removeFromSuperview];
       [MyRootRequest GetUrlWithString:self.urlStr WithRequestSuccess:^(id object) {
        NSDictionary *dict = object[@"Data"];
        NSArray *list = dict[@"List"];
        if ([self.urlStr isEqualToString:[NSString stringWithFormat:@"http://a.17173.com/api/photos/list?platCode=IOS&maxPublicDate=0&pageSize=10&sections=%@",self.Section]]) {
            [self.arr_data removeAllObjects];
            [self.arr_cellurl removeAllObjects];
        }
        for (NSDictionary *d in list) {
            self.cellStr = @"http://a.17173.com/api/photos/detail?platCode=IOS&photosID=";
            NSNumber *ID = d[@"ID"];
            self.cellStr = [self.cellStr stringByAppendingString:[NSString stringWithFormat:@"%@",ID]];
            [self.arr_cellurl addObject:self.cellStr];
            
        }
        
        [self.arr_data addObjectsFromArray:list];
        [self.tv reloadData];
        [self.tv.mj_header endRefreshing];
        [self.tv.mj_footer endRefreshing];
        NSNumber *PublicDate = [[self.arr_data lastObject] objectForKey:@"PublicDate"];
        self.urlStr = [NSString stringWithFormat:@"http://a.17173.com/api/photos/list?platCode=IOS&maxPublicDate=%@&pageSize=10&sections=%@",PublicDate,self.Section];
    } WithRequestFailed:^(NSError *error) {
    }];
    

 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 172;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr_data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellname = @"mengmeizi";
    MengmeiziCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    MengmeiziModel *model = [[MengmeiziModel alloc]initWithWithDict:self.arr_data[indexPath.row]];
    [cell setupWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *Section = self.arr_data[indexPath.row][@"Section"];
    [self LoadCellData:self.arr_cellurl[indexPath.row] Andtitle:self.arr_data[indexPath.row][@"Title"]AndTopTitle:Section[@"Title"]];
    NSLog(@"str - %@",self.arr_cellurl[indexPath.row]);
    
}
//读取cell下级界面数据
- (void)LoadCellData:(NSString *)urlStr Andtitle:(NSString *)title AndTopTitle:(NSString *)toptitle
{
    [MyRootRequest GetUrlWithString:urlStr  WithRequestSuccess:^(id object) {
        NSDictionary *data = object[@"Data"];
        NSArray *arr = data[@"List"];
        [self turnToCellView:arr Andtitle:title AndTopTitle:toptitle];
    } WithRequestFailed:^(NSError *error) {
        
    }];
}
//跳转到cell下级界面
- (void)turnToCellView:(NSArray *)arr_data Andtitle:(NSString *)title AndTopTitle:(NSString *)toptitle
{
    JiongViewController *jc = [[UIStoryboard storyboardWithName:@"JiongStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"jiongview"];
    jc.arr_data = arr_data;
    NSLog(@"%@",arr_data);
    jc.title = title;
    jc.TopTitle = toptitle;
    [self.navigationController pushViewController:jc animated:YES];
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
