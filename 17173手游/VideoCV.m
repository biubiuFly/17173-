//
//  VideoCV.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/12.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "VideoCV.h"
#import "MyRootRequest.h"
#import "MJ17173Header.h"
#import "MJ17173Footer.h"
#import "MJRefresh.h"
#import "VideoModel.h"
#import "VideoCell.h"
#import "VideoHeadView.h"
#import "NewsWebViewController.h"
#import "AppDelegate.h"
#import "AlertMonmentView.h"
@interface VideoCV ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)NSMutableDictionary *dict_body;
@property(nonatomic,strong)NSMutableArray *arr_data;
@property(nonatomic,strong)NSMutableArray *arr_headData;
@property(nonatomic,strong)NSString *videoID;
@property(nonatomic)NSInteger curPage;
@end

@implementation VideoCV

static NSString * const reuseIdentifier = @"video";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setCV];
    [self beginReques];
    
}


- (void)setCV{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.mj_header = [MJ17173Header headerWithRefreshingBlock:^{
        [self setNoNetAlertView];
        [self.dict_body setValue:@"0" forKey:@"vts"];
        [self.dict_body setValue:@"1" forKey:@"page"];
        [self beginReques];
    }];
    self.collectionView.mj_footer = [MJ17173Footer footerWithRefreshingBlock:^{
        [self.arr_headData removeAllObjects];
        [self beginReques];
    }];
}
- (void)setData{
    self.arr_data = [NSMutableArray array];
    self.arr_headData= [NSMutableArray  array];
    
}
-(void)setupWithVideoID:(NSString *)videoID
{
    self.urlStr = [NSString stringWithFormat:@"http://a.17173.com/cms/v3/rest/ops/column/%@/video",videoID];
    self.videoID = videoID;
    self.dict_body = [@{
                        @"size":@"25",
                        @"id":videoID,
                        @"vts":@"0",
                        @"page":@"1"
                        }mutableCopy];
    
}
- (void)setNoNetAlertView
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isNetWorking == NO) {
        UIView *view = [AlertMonmentView createSubViewWithText:@"哎呀，手机好像没连上网" WithWidth:200 WithHeight:30];
        view.frame = CGRectMake(80, [UIScreen mainScreen].bounds.size.height-60-64-60, 200, 30);
        
        [self.view addSubview:view];
        [self.collectionView.mj_header endRefreshing];
    }else{
        [self.arr_data removeAllObjects];
        [self.arr_headData removeAllObjects];
    }
    
}

-(void)beginReques{
    NSDictionary *head = @{
                           @"User-Agent":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                           @"Content-Type":@"application/json",
                           @"c":@"1p4Q39QwdZYsB5HTfTweehnRm5XHPZA47J3WNaBBlLdPkINN5iFPlA==",
                           @"k":@"aaZCadQzSBiEa4/xSlmV63ZbxL4bi1SN530S5Y03jVVlEfGn9O9Op1bGarAQTz0WMei/Nm2BcUceJ4bVKGD+mg=="
                           };
    [MyRootRequest PostUrlWithString:self.urlStr WithHeaderDict:head WithParam:self.dict_body WithRequestSuccess:^(id object) {
        NSArray *list = object[@"result"][@"content"];
        NSNumber *curp = object[@"result"][@"curPage"];
        self.curPage = curp.integerValue;
        [self.arr_data addObjectsFromArray:list];
        for (NSDictionary *dict in self.arr_data) {
            NSString *bigPicUrl = dict[@"bigPicUrl"];
            if (bigPicUrl.length>0) {
                [self.arr_headData addObject:dict];
            }
            
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.dict_body setValue:[NSString stringWithFormat:@"%@",[list lastObject][@"videoTimeStamp"]] forKey:@"vts"];
        [self.dict_body setValue:[NSString stringWithFormat:@"%ld",self.curPage+1] forKey:@"page"];
    } WithRequestFailed:^(NSError *error) {
        
    }];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.arr_data.count - self.arr_headData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    VideoModel *model = [[VideoModel alloc]initWithDict:self.arr_data[indexPath.item+self.arr_headData.count]];
    [cell setupWithModel:model];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
        VideoHeadView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"videohead" forIndexPath:indexPath];
    head.tapImage = ^(NewsWebViewController *nw){
        [self.navigationController pushViewController:nw animated:YES];
    };
        [head setupWithArray:self.arr_headData];
        return head;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        NewsWebViewController * nw = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"newwebview"];
        nw.urlStr = self.arr_data[indexPath.item+self.arr_headData.count][@"videoUrl"];
    nw.webTitle = @"视频";
        [self.navigationController pushViewController:nw animated:YES];
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
