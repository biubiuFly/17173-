//
//  JiongViewController.m
//  17173手游
//
//  Created by 吴永康 on 2016/12/5.
//  Copyright © 2016年 吴永康. All rights reserved.
//

#import "JiongViewController.h"
#import "MyNavBar.h"
#import "MyNavViewController.h"
#import "UIImageView+WebCache.h"
@interface JiongViewController ()<MyNavBarDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *sc;
@property (nonatomic, strong) MyNavBar *nav;

@end

@implementation JiongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav = ((MyNavViewController *)self.navigationController).nav;
    self.nav.delegate = self;
    [self setUI];

}
- (void)viewWillAppear:(BOOL)animated
{
    self.nav.label_title.text = self.TopTitle;
    [self.nav.btn_right setImage:[UIImage imageNamed:@"game_common_comment"] forState:UIControlStateNormal];
}
- (void)setUI
{
    CGSize contentMaxSize = CGSizeMake(300, MAXFLOAT);
    NSDictionary *attributesDict = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:15]
                                     };
    NSDictionary *attributesDict1 = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:15]
                                     };

CGSize contentRealSize =  [self.title boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDict context:nil].size;
    CGFloat space = 10;
    UILabel *label_title = [[UILabel alloc]initWithFrame:CGRectMake(space, space, contentRealSize.width, contentRealSize.height)];
    label_title.text = self.title;
    label_title.font = [UIFont systemFontOfSize:15];
    label_title.numberOfLines = 0;
    [self.sc addSubview:label_title];
    CGFloat sum = space + label_title.bounds.size.height;
    for (int i = 0; i<self.arr_data.count; i++) {
        if (self.arr_data[i][@"BigUrl"] !=[NSNull null]) {
            NSNumber *bigwidth = self.arr_data[i][@"BigWidth"];
            NSNumber *bigheight = self.arr_data[i][@"BigHeight"];
            CGFloat iv_height = (320/bigwidth.doubleValue)*bigheight.doubleValue;
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, sum+space, 320, iv_height)];
            [iv sd_setImageWithURL:[NSURL URLWithString:self.arr_data[i][@"BigUrl"]] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
            [self.sc addSubview:iv];
            sum+=iv_height;
        }
        
        if (self.arr_data[i][@"Content"] != [NSNull null] ) {
            /**label读取HTML语句*/
            NSString * htmlString = self.arr_data[i][@"Content"];
            NSAttributedString *attrStr = [[NSAttributedString alloc]initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            CGSize TextRealSize =  [self.arr_data[i][@"ContentText"] boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDict1 context:nil].size;
            UILabel *label_text = [[UILabel alloc]initWithFrame:CGRectMake(space, sum+space, TextRealSize.width, TextRealSize.height)];
            label_text.attributedText = attrStr;
            label_text.numberOfLines = 0;
//            label_text.font = [UIFont systemFontOfSize:15];
            [self.sc addSubview:label_text];
            sum+=TextRealSize.height;
        }
        
        sum+=space;

    }
    self.sc.contentSize = CGSizeMake(320, sum);
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
- (void)click_left
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.nav.label_title.text = @"17173网游";
    [self.nav.btn_right setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
}
@end
