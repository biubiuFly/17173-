//
//  ZXGL.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "ZQGL.h"
#import "MyRootRequest.h"
#import "ZQGLModel.h"
#import "ZQGLCell.h"
#import "MJRefresh.h"
#import "MJ17173Header.h"
#import "AppDelegate.h"
#import "AlertMonmentView.h"
@interface ZQGL ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *arr_data;
@property (nonatomic,strong)NSDictionary *head;
@end

@implementation ZQGL

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setTV];
    [self beginReques];
}
- (void)setData{
    self.arr_data = [NSMutableArray array];
    self.head = @{
                  @"User-Agent":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                  @"Content-Type":@"application/json",
                  @"c":@"N9q9jVq7Yh8Ot0Vc7FGTuETaWUFljLe1AT1TFwFuwoGMo+nlIVoWrg==",
                  @"k":@"ki92MtcWvTr6WELVTQkWp3CYKvk92YRQt6VbBKY1TY+wdakcChRR0gW7/XPPGgNH3dKr6WgYDJ8NBNgV16dJqQ=="
                  };
}
-(void)setTV
{
    self.tableView.delegate     =   self;
    self.tableView.dataSource   =   self;
    self.tableView.mj_header = [MJ17173Header headerWithRefreshingBlock:^{
        
        [self beginReques];
        [self setNoNetAlertView];
    }];
}
- (void)beginReques{
    [MyRootRequest GetUrlWithString:@"http://a.17173.com/cms/v3/rest/cont/zqstrategy?type=1&size=100&page=1" WithHeader:self.head WithRequestSuccess:^(id object) {
        [self.arr_data removeAllObjects];
        NSArray *data = object[@"strategy"];
        [self.arr_data addObjectsFromArray:data];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } WithRequestFailed:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arr_data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQGLCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zqgl" forIndexPath:indexPath];
    ZQGLModel *model = [[ZQGLModel alloc]initWithDict:self.arr_data[indexPath.row]];
    [cell setupWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"需要下载最强攻略客户端，才能查看具体内容哦，是否立即下载" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:action];
    [ac addAction:action1];
    [self presentViewController:ac animated:YES completion:^{
        
    }];
}
- (void)setNoNetAlertView
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isNetWorking == NO) {
        UIView *view = [AlertMonmentView createSubViewWithText:@"哎呀，手机好像没连上网" WithWidth:200 WithHeight:30];
        view.frame = CGRectMake(80, [UIScreen mainScreen].bounds.size.height-60-64-60, 200, 30);
        
        [self.view addSubview:view];
    }
    [self.tableView.mj_header endRefreshing];
}

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
