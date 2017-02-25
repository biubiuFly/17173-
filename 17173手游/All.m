//
//  All.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/10.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "All.h"
#import "MyRootRequest.h"
#import "AllModel.h"
#import "AllCell.h"
#import "MJRefresh.h"
#import "MJ17173Header.h"
#import "GLxiaji.h"
#import "SectionView.h"
#import "AppDelegate.h"
#import "AlertMonmentView.h"
@interface All ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong)NSDictionary *head;
@property (nonatomic,strong)NSMutableArray *arr_data;
@property (nonatomic,strong)NSMutableArray *arr_section;
@property (nonatomic,strong)NSDictionary *dict_dingyue;
@property (nonatomic,strong)UIView *view_section;
@property (nonatomic,strong)SectionView *sv;
@end

@implementation All

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setTv];
    [self beginReques];

}
- (void)setTv{
    self.tableView.delegate     =   self;
    self.tableView.dataSource   =   self;
    self.tableView.showsVerticalScrollIndicator =   NO;
    self.tableView.mj_header    = [MJ17173Header headerWithRefreshingBlock:^{

        [self beginReques];
        [self setNoNetAlertView];
    }];
}
- (void)setData{
    self.head = @{
                  @"User-Agent":@"17173_3.3.0700_A0010310283_EA1125F15D3900E4A4ACB27FE9C4D8A5B8989B09(iPad; iPhone OS 10.1.1; zh_CN)",
                  @"Content-Type":@"application/json",
                  @"c":@"N9q9jVq7Yh8Ot0Vc7FGTuETaWUFljLe1AT1TFwFuwoGMo+nlIVoWrg==",
                  @"k":@"ki92MtcWvTr6WELVTQkWp3CYKvk92YRQt6VbBKY1TY+wdakcChRR0gW7/XPPGgNH3dKr6WgYDJ8NBNgV16dJqQ=="
                  };
    self.arr_data       =   [NSMutableArray array];
    self.arr_section    =   [NSMutableArray array];
}
- (void)beginReques{
    [MyRootRequest GetUrlWithString:@"http://a.17173.com/cms/v3/rest/cont/strategy?size=100&type=2&category=3&page=1" WithHeader:self.head WithRequestSuccess:^(id object) {
        [self.arr_data removeAllObjects];
        [self.arr_section removeAllObjects];
        NSArray *list = object[@"strategy"];
        NSMutableArray *arr_dingyue = [NSMutableArray array];
        for (int c = 'a'; c<='z'; c++) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in list) {
                int a =[dict[@"namePinyin"] characterAtIndex:0];
                if (a==c || a+32 == c) {
                    [arr addObject:dict];
                }
            }
            if (arr.count>0) {
                [self.arr_data addObject:arr];
                int S = c-32;
                NSString *str = [NSString stringWithFormat:@"%c",S];
                [self.arr_section addObject:str];
            }
           
        }
        for (NSDictionary *dd in list) {
            [arr_dingyue addObject:dd[@"gameCode"]];
        }
        NSDictionary *body = @{
                               @"gameSubCount":@"1",
                               @"gameCodes":arr_dingyue,
                               @"live":@"1"
                               };
        [MyRootRequest PostUrlWithString:@"http://a.17173.com/cms/v3/rest/cont/game/content" WithHeaderDict:self.head WithParam:body WithRequestSuccess:^(id object) {
            self.dict_dingyue = object[@"result"];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (self.view_section==nil) {
                [self setsectionIndexTitles];
            }
        } WithRequestFailed:^(NSError *error) {
            
        }];
        
       
    } WithRequestFailed:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arr_data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    for (int i = 0; i<self.arr_data.count; i++) {
        if (section == i) {
            NSArray *arr =self.arr_data[i];
            return arr.count;
        }
    }
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.arr_section[section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllCell *cell = [tableView dequeueReusableCellWithIdentifier:@"all" forIndexPath:indexPath];
    NSArray *arr        =   self.arr_data[indexPath.section];
    AllModel *model     =   [[AllModel alloc]initWithDict:arr[indexPath.row]];
    
    NSString *key   =   [NSString stringWithFormat:@"%@",arr[indexPath.row][@"gameCode"]];
    model.dingyuecount  =   self.dict_dingyue[key][@"gameSubCount"];
    [cell setupWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLxiaji *xj = [[UIStoryboard storyboardWithName:@"Tactic" bundle:nil] instantiateViewControllerWithIdentifier:@"glxj"];
    NSArray *arr = self.arr_data[indexPath.section];
    NSString *name =arr[indexPath.row][@"name"];
    [xj setupWithID:arr[indexPath.row][@"id"] andHeadDict:self.head andTitle:name];
    [self.navigationController pushViewController:xj animated:YES];
    
}
//-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    tableView.sectionIndexColor = [UIColor grayColor];
//    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
//    return self.arr_section;
//}
- (void)setsectionIndexTitles{
    CGRect frame = self.tableView.bounds;
    self.view_section = [[UIView alloc]initWithFrame:CGRectMake(640+frame.size.width-20, 0, 20, frame.size.height)];
    self.view_section.backgroundColor = [UIColor whiteColor];
    self.view_section .alpha = 0.5;
    CGFloat height = frame.size.height/self.arr_section.count;
    for (int i = 0; i<self.arr_section.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*height, 20, height)];
        [btn setTitle:self.arr_section[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.tag = i;
        [btn addTarget:self action:@selector(click_btn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view_section addSubview:btn];
    }
    [self.view.superview addSubview:self.view_section];
}
- (void)click_btn:(UIButton *)btn{
    CGRect section_frame = [self.tableView rectForSection:btn.tag];
    self.tableView.contentOffset = CGPointMake(0, section_frame.origin.y);
}


-(SectionView *)sv
{
    if (_sv == nil) {
        _sv = [[[NSBundle mainBundle]loadNibNamed:@"SectionView" owner:nil options:nil]lastObject];
        _sv.frame = CGRectMake(640+135, (self.tableView.bounds.size.height-50)/2, 50, 50);
        [self.view.superview addSubview:_sv];
    }
    return _sv;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        for (int i = 0; i<self.arr_section.count; i++){
            CGRect frame = [self.tableView rectForSection:i];
            if ((self.tableView.contentOffset.y >= frame.origin.y-10.0) &&(self.tableView.contentOffset.y <= frame.origin.y+10.0)) {
                    self.sv.label_sectionName.text = self.arr_section[i];
            }
        }
    }
}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (scrollView == self.tableView) {
//        [UIView animateWithDuration:3 animations:^{
//            self.sv.alpha = 0;
//            self.sv.label_sectionName.alpha = 0;
//        } completion:^(BOOL finished) {
//            [self.sv removeFromSuperview];
//            self.sv = nil;
//        }];
//    }
//}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        self.sv.alpha = 1;
    }
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (scrollView == self.tableView) {
        [UIView animateWithDuration:3 animations:^{
            self.sv.alpha = 0;
        } completion:^(BOOL finished) {
//            [self.sv removeFromSuperview];
//            self.sv = nil;
        }];
    }
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
@end
