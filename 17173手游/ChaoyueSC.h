

#import <UIKit/UIKit.h>

typedef void(^ClickAction)(NSInteger currentPage);



@interface ChaoyueSC : UIView
//在调用下面方法前，请先引入第三方库SDWebImage









/**
 滚动轮播图（自动滚动+循环拖动）

 @param arr      包含字典的数组（即从网络上解析的数组）
 @param PCrect   PageControl的位置
 @param interval 自动滚动的时间间隔
 @param picName  字典中图片对应的key（需为网络地址）
 @param Tap      图片的点击事件(点击一次触发),同时返回当前图片的页数
 */
-(void)setupUIwithArr:(NSArray*)arr andPageControlFrame:(CGRect)PCrect
      SetTimeInterval:(NSTimeInterval )interval KeyInDictWith:(NSString *)picName WithImageHeighe:(CGFloat)imageHeight addTapAction:(ClickAction)Tap ;
-(void)setupUIwithArr:(NSArray*)arr andPageControlFrame:(CGRect)PCrect
      SetTimeInterval:(NSTimeInterval )interval KeyInDictWith:(NSString *)picName WithImageHeighe:(CGFloat)imageHeight TitleKeyInDictWith:(NSString *)title addTapAction:(ClickAction)Tap ;

@end
