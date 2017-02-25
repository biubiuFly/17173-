//
//  laosiji.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/4.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "laosiji.h"
#import "MyRootRequest.h"
#import "LaosijiModel.h"
#import "LaosijiCell.h"
#import "MJRefresh.h"
#import "MJ17173Header.h"
#import "MJ17173Footer.h"
#import "JiongViewController.h"
@interface laosiji ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (strong, nonatomic) NSMutableArray *arr_data;
@property (assign, nonatomic) NSInteger data_Total;
@property (strong, nonatomic) NSString *urlStr;
@property (strong, nonatomic) NSString *cellStr;
@property (strong, nonatomic) NSMutableArray *arr_cellurl;
@property (strong, nonatomic) NSDictionary *head;
@end

@implementation laosiji
- (void)viewWillAppear:(BOOL)animated
{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setTv];
    [self beginReques];
}

- (void)setTv
{
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.mj_header = [MJ17173Header headerWithRefreshingBlock:^{
        self.urlStr = @"http://a.17173.com/api/photos/list?sections=7&platCode=ANDROID";
        [self beginReques];
    }];
    
    self.tv.mj_footer = [MJ17173Footer footerWithRefreshingBlock:^{
        [self beginReques];
    }];
}

- (void)setData
{
    self.arr_data = [NSMutableArray array];
    self.arr_cellurl = [NSMutableArray array];
    self.urlStr = @"http://a.17173.com/api/photos/list?sections=7&platCode=ANDROID";
    _head = @{
                           @"User-Agent":@"17173_3.4.0100_A0017025221_9474af11-23c9-37a6-8a1b-22a9819bda45(android_OS_5.1.1;Xiaomi_Redmi 3)-23c9-37a6-8a1b-22a9819bda45(android_OS_5.1.1;Xiaomi_Redmi 3)",
                           @"v":@"3.0",
                           @"i":@"17173_3.4.0100_A0017025221_9474af11",
                           @"c":@"lOHX/8cHbJG6iK/B0tofStmhXHov7NqCa/11Rml2UAappfN0lqt3qw==",
                           @"Content-Type":@"application/json",
                           @"k":@"m/0becd1WUCbKSP3wJVo/BHYfUTHgeomUSfMHikP1M7PYcSNhx9mPAlyr2ArqNZmA9GTfMirseQbyzU5qrOXqA=="
                           };
}


- (void)beginReques
{
    [MyRootRequest GetUrlWithString:self.urlStr WithHeader:_head WithRequestSuccess:^(id object) {
        NSDictionary *dict = object[@"Data"];
        NSNumber *Total =dict[@"Total"];
        self.data_Total = Total.integerValue;
        NSArray *list = dict[@"List"];
        if ([self.urlStr isEqualToString:@"http://a.17173.com/api/photos/list?sections=7&platCode=ANDROID"]) {
            [self.arr_data removeAllObjects];
            [self.arr_cellurl removeAllObjects];
        }
        //http://a.17173.com/api/photos/detail?platCode=ANDROID&photosID=14208

        for (NSDictionary *d in list) {
    self.cellStr = @"http://a.17173.com/api/photos/detail?platCode=ANDROID&photosID=";
            NSNumber *ID = d[@"ID"];
            self.cellStr = [self.cellStr stringByAppendingString:[NSString stringWithFormat:@"%@",ID]];
            [self.arr_cellurl addObject:self.cellStr];
            self.cellStr = [self.urlStr stringByAppendingString:@"&photosID="];
        }
        NSLog(@"cellurlstr - %@",self.arr_cellurl);
        [self.arr_data addObjectsFromArray:list];
        NSNumber *PublicDate = [[self.arr_data lastObject] objectForKey:@"PublicDate"];
        [self.tv reloadData];
        NSString *ss = @"http://a.17173.com/api/photos/list?sections=7&platCode=ANDROID&maxPublicDate=";
        self.urlStr = [ss stringByAppendingString:[NSString stringWithFormat:@"%@",PublicDate]];

    } WithRequestFailed:^(NSError *error) {
        
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *Section = self.arr_data[indexPath.row][@"Section"];
    [self LoadCellData:self.arr_cellurl[indexPath.row] Andtitle:self.arr_data[indexPath.row][@"Title"]AndTopTitle:Section[@"Title"]];
    NSLog(@"cellurl - %@",self.arr_cellurl[indexPath.row]);
    
}
//读取cell下级界面数据
- (void)LoadCellData:(NSString *)urlStr Andtitle:(NSString *)title AndTopTitle:(NSString *)toptitle
{
    [MyRootRequest GetUrlWithString:urlStr WithHeader:_head WithRequestSuccess:^(id object) {
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
    jc.title = title;
    jc.TopTitle = toptitle;
    [self.navigationController pushViewController:jc animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr_data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellname = @"laosiji";
    LaosijiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    LaosijiModel *model = [[LaosijiModel alloc]initWithWithDict:self.arr_data[indexPath.row]];
    [cell setupWithModel:model];
    return cell;
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
