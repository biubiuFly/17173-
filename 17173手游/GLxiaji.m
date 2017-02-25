//
//  GLxiaji.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "GLxiaji.h"
#import "MyRootRequest.h"
#import "MyNavViewController.h"
#import "MyNavBar.h"
#import "glxjCell.h"
#import "glxjModel.h"
#import "glxjhead.h"
@interface GLxiaji ()<UICollectionViewDelegate,UICollectionViewDataSource,MyNavBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *cv;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *cf;
@property (nonatomic,strong) NSMutableArray *arr_data;
@property (nonatomic,strong) NSMutableArray *arr_topdata;
@property (nonatomic,strong) NSDictionary *dict_strategy;
@property (nonatomic,strong) glxjhead *headView;
@property (nonatomic,strong) MyNavBar *nav;
@property (nonatomic,strong)NSNumber *ID;
@property (nonatomic,strong)NSDictionary *head;
@property (nonatomic,strong)NSString *tit;
@end

@implementation GLxiaji

-(void)viewWillAppear:(BOOL)animated
{
    self.nav.delegate = self;
    self.nav.label_title.text = self.tit;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setCV];
    [self beginRequest];
    self.nav = ((MyNavViewController *)self.navigationController).nav;
}
- (void)setupWithID:(NSNumber *)ID andHeadDict:(NSDictionary *)dict andTitle:(NSString *)title
{
    self.ID     =   ID;
    self.head   =   dict;
    self.tit    =   title;
}
- (void)setCV{
    self.cv.delegate    = self;
    self.cv.dataSource  = self;
}
- (void)setData{
    self.arr_data       = [NSMutableArray array];
    self.arr_topdata    = [NSMutableArray array];
}
- (void)beginRequest{
    [MyRootRequest GetUrlWithString:[NSString stringWithFormat:@"http://a.17173.com/cms/v3/rest/cont/strategy/shouyou/%@",self.ID] WithHeader:self.head WithRequestSuccess:^(id object) {
        NSArray *arr_top = object[@"result"][@"focusImages"];
        self.dict_strategy = object[@"result"][@"strategy"];
        [self.arr_topdata addObjectsFromArray:arr_top];
        [self.cv reloadData];
    } WithRequestFailed:^(NSError *error) {
        
    }];
    [MyRootRequest GetUrlWithString:[NSString stringWithFormat:@"http://a.17173.com/cms/v3/rest/cont/strategy/%@/menu?mts=0",self.ID] WithHeader:self.head WithRequestSuccess:^(id object) {
        NSArray * celldata = object[@"result"][@"menu"];
        [self.arr_data addObjectsFromArray:celldata];
        [self.cv reloadData];
    } WithRequestFailed:^(NSError *error) {
        NSLog(@"dasdasd");
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arr_data.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellname = @"glcv";
    glxjCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellname forIndexPath:indexPath];
    glxjModel *model = [[glxjModel alloc]initWithDict:self.arr_data[indexPath.row]];
    [cell setupWithModel:model];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        glxjhead *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        
        [head setupWithArray:self.arr_topdata andStrategy:self.dict_strategy];
        return head;
    }else
    {
        return nil;
    }
}
-(void)click_left
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.nav.label_title.text = @"攻略";
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
