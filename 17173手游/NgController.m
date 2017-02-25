//
//  NgController.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/8.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "NgController.h"
#import "MyRootRequest.h"
#import "NgCell.h"
#import "NgModel.h"
#import "MJRefresh.h"
#import "MJ17173Footer.h"
#import "MJ17173Header.h"
#import "NewsWebViewController.h"
#import "AppDelegate.h"
#import "AlertMonmentView.h"
@interface NgController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSDictionary *header;
@property (nonatomic,strong)NSMutableDictionary *body;
@property (nonatomic,strong)NSString *urlStr;
@property (nonatomic,strong)NSMutableArray *arr_data;
@property (nonatomic)NSInteger page;
@end

@implementation NgController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setData];
    [self setTV];
    [self beginReques];
}

- (void)setTV
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = [MJ17173Header headerWithRefreshingBlock:^{
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
    self.tableView.mj_footer = [MJ17173Footer footerWithRefreshingBlock:^{
        [self beginReques];
    }];
}
- (void)setData
{
    self.arr_data = [NSMutableArray array];
}

//初始化方法
- (void)setupWithUrlStr:(NSString *)urlStr andHeadDict:(NSDictionary *)head {
    self.urlStr = urlStr;
    self.header = head;
    self.body = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                @"size":@"20",
                                                                @"menu":@"0",
                                                                @"page":@"1",
                                                                @"orderts":@"0"
                                                                } ];
    [self beginReques];
}

//无网络弹窗
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

//网络请求数据
- (void)beginReques{
    [MyRootRequest PostUrlWithString:self.urlStr WithHeaderDict:self.header WithParam:self.body WithRequestSuccess:^(id object) {
        NSArray *arr = object[@"result"][@"content"];
        NSNumber *p =object[@"result"][@"curPage"];
        self.page = p.integerValue;
        [self.arr_data addObjectsFromArray:arr];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *d = [arr lastObject];
        [self.body setValue:[NSString stringWithFormat:@"%ld",self.page+1] forKey:@"page"];
        [self.body setValue:d[@"orderts"] forKey:@"orderts"];
    } WithRequestFailed:^(NSError *error) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr_data.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsWebViewController * nw = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"newwebview"];
    nw.urlStr = self.arr_data[indexPath.row][@"newsUrl"];
    [self.navigationController pushViewController:nw animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellname = @"cellname";
        
    NgCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NgCell" owner:nil options:nil] lastObject];
    }
    NgModel *model = [[NgModel alloc]initWithDict:self.arr_data[indexPath.row]];
    [cell setupWithModel:model];
    return cell;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
