//
//  recommend.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "recommend.h"
#import "MyRootRequest.h"
#import "MJRefresh.h"
#import "MJ17173Header.h"
#import "MJ17173Footer.h"
#import "recommendCell.h"
#import "recommendModel.h"
#import "GLxiaji.h"
#import "AppDelegate.h"
#import "AlertMonmentView.h"
@interface recommend ()
@property (nonatomic,strong) NSMutableArray *arr_data;
@property (nonatomic,strong) NSMutableDictionary *arr_dingyueCount;
@property (nonatomic,strong) NSDictionary *head;
@end

@implementation recommend

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setTv];
    [self beginReques];
}
- (void)setData{
    self.arr_data           = [NSMutableArray array];
    self.arr_dingyueCount   = [NSMutableDictionary dictionary];
    self.head = @{
                           @"User-Agent":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                           @"Content-Type":@"application/json",
                           @"c":@"zQ+D8nH0lNyXq2roC4dSujRyoWv3s7WDy+YBFMU7XT7O2G12qRkggw==",
                           @"k":@"UleGUxSmv37qyZUJsnScoI8TDFQ/0nhBZumRdKomQ93PeqTfKFLSYFJkEIfOJfnzD6uWym1ZXJ7UA4cf0W/bIQ==",
                           @"v":@"3.0"
                           };
}
- (void)setTv{
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    self.tableView.mj_header    = [MJ17173Header headerWithRefreshingBlock:^{

        [self beginReques];
        [self setNoNetAlertView];
    }];
}
- (void)beginReques{
    NSMutableArray *arr_gameCodes = [NSMutableArray array];
    NSMutableDictionary *body = [@{
                                   @"type":@"2",
                                   @"gameCodes":arr_gameCodes,
                                   }mutableCopy];
    [MyRootRequest PostUrlWithString:@"http://a.17173.com/cms/v3/rest/cont/strategy/rec" WithHeaderDict:self.head WithParam:body WithRequestSuccess:^(id object) {
        [self.arr_data removeAllObjects];
        NSArray *list =  object[@"result"][@"recStrategy"];
        [self.arr_data addObjectsFromArray:list];
        for (NSDictionary *d in self.arr_data) {
            [arr_gameCodes addObject:d[@"gameCode"]];
        }
        NSDictionary *bod = @{
                              @"gameSubCount":@"1",
                              @"gameCodes":arr_gameCodes,
                              @"live":@"1"
                              };
        [MyRootRequest PostUrlWithString:@"http://a.17173.com/cms/v3/rest/cont/game/content" WithHeaderDict:self.head WithParam:bod WithRequestSuccess:^(id object) {
            NSDictionary *dict = object[@"result"];
            self.arr_dingyueCount = [dict mutableCopy];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } WithRequestFailed:^(NSError *error) {
            
        }];

    } WithRequestFailed:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arr_data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellname = @"tuijian";
    recommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname forIndexPath:indexPath];
    recommendModel *model = [[recommendModel alloc]initWithDict:self.arr_data[indexPath.row]];
    NSString *key =  [NSString stringWithFormat:@"%@",self.arr_data[indexPath.row][@"gameCode"]];
    
    
    /*
     注意：key一定是个nsstring类型，如果key恰好是个数字
     注意看好这个数字是不是nsnumber类型
     如果是要转成nsstring才可以作为key从字典中取值
     */
    
//    ?NSDictionary *d_dingyue = [self.arr_dingyueCount objectForKey:key];
    
    NSString *dingyue = self.arr_dingyueCount[key][@"gameSubCount"];
    
    model.dingyue = dingyue;
    [cell setupWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLxiaji *xj = [[UIStoryboard storyboardWithName:@"Tactic" bundle:nil] instantiateViewControllerWithIdentifier:@"glxj"];
    NSString *name =self.arr_data[indexPath.row][@"name"];
    [xj setupWithID:self.arr_data[indexPath.row][@"id"] andHeadDict:self.head andTitle:name];
    [self.navigationController pushViewController:xj animated:YES];
    
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
