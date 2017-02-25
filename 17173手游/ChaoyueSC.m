
#import "ChaoyueSC.h"
#import "UIImageView+WebCache.h"

#define SW [UIScreen mainScreen].bounds.size.width
#define SH [UIScreen mainScreen].bounds.size.height

@interface ChaoyueSC ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *sc;
@property(nonatomic,strong)UIPageControl*pc;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic)CGRect rect;
@property (nonatomic) CGFloat imageHeight;
@property(nonatomic,strong)NSString *picName;
@property(nonatomic,strong)ClickAction action;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)UILongPressGestureRecognizer*longp;
@property(nonatomic)NSTimeInterval interval;
@property(nonatomic,strong)NSString *titName;
@property(nonatomic,strong)UIView*titView;
@property(nonatomic,strong)UILabel*label;
@end


@implementation ChaoyueSC


#pragma mark - initViews

-(instancetype)init
{
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    [self setupSC];
    [self setupPC];
}

-(void)setupSC{
    
    self.sc = [[UIScrollView alloc]initWithFrame:self.frame];
    
    self.sc.delegate=self;
    self.sc.pagingEnabled=YES;
    self.sc.showsHorizontalScrollIndicator=NO;
    
    //初始偏移量
    self.sc.contentOffset=CGPointMake(SW*1, 0);
    [self addSubview:self.sc];
}

- (void)setupPC
{
    //小滚轮
    self.pc=[[UIPageControl alloc]initWithFrame:self.frame];
    self.pc.currentPage=0;
    self.pc.currentPageIndicatorTintColor=[UIColor orangeColor];
    
    [self addSubview:self.pc];
    [self bringSubviewToFront:self.pc];
}


#pragma mark - 数据赋值
-(void)setupUIwithArr:(NSArray *)arr andPageControlFrame:(CGRect)PCrect SetTimeInterval:(NSTimeInterval)interval KeyInDictWith:(NSString *)picName WithImageHeighe:(CGFloat)imageHeight addTapAction:(ClickAction)Tap
{
    //给pc重新画frame
    [self setupUIwithArr:arr andPageControlFrame:PCrect SetTimeInterval:interval KeyInDictWith:picName WithImageHeighe:imageHeight TitleKeyInDictWith:nil addTapAction:Tap];
    
}

-(void)setupUIwithArr:(NSArray*)arr andPageControlFrame:(CGRect)PCrect
      SetTimeInterval:(NSTimeInterval )interval KeyInDictWith:(NSString *)picName WithImageHeighe:(CGFloat)imageHeight TitleKeyInDictWith:(NSString *)title addTapAction:(ClickAction)Tap {
    self.pc.frame = PCrect;
    self.picName=picName;
    self.titName=title;
    self.interval=interval;
    self.imageHeight = imageHeight;
    _action=Tap;
    [self setupWithArr:arr];
    if (arr.count >1) {
        [self setupTimer];
    }

}
-(void)setupWithArr:(NSArray *)arr{
    
    //防止未赋值调用
    if (arr.count == 0) {
        return;
    }
    
    //设置sc的数据
    self.sc.contentOffset = CGPointMake(SW, 0);
    self.sc.contentSize=CGSizeMake(SW*(arr.count+2),SW/4/79*80);
    
    //设置pc的数据
    self.pc.numberOfPages = arr.count;
    self.pc.currentPage = 0;
    
    //画UI
    for (int i=0; i<arr.count+2; i++) {
        int num=0;
        
        if (i==0) {
            num = (int)arr.count-1;
        }else if(i==arr.count+1){
            num = 0;
        }else{
            num = i-1;
        }
        
        NSDictionary*dict=arr[num];
        
        UIImageView*iv=[[UIImageView alloc]initWithFrame:CGRectMake(i*SW, 0, SW, self.imageHeight)];
        [iv sd_setImageWithURL:[NSURL URLWithString:dict[self.picName]] placeholderImage:[UIImage imageNamed:@"placeholder_612_250"]];
        //需要设置title
        if (self.titName!=nil) {
            [self setupTitView];
            [iv addSubview:self.titView];
            self.label.text=dict[self.titName];
        }
        //人机交互
        self.sc.userInteractionEnabled=YES;
        iv.userInteractionEnabled=YES;
        //添加手势
        [self TapGes];
        
        [iv addGestureRecognizer:self.tap];

        [self.sc addSubview:iv];
    }
}
//半透明titleview
-(void)setupTitView{
    self.titView=[[UIView alloc]initWithFrame:CGRectMake(0,self.imageHeight-30, self.sc.bounds.size.width, 30)];
    self.titView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.7];
    self.label=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, self.titView.bounds.size.width-50, 30)];
    self.label.numberOfLines=1;
    self.label.tintColor=[UIColor blackColor];
    self.label.font=[UIFont systemFontOfSize:15];
    [self.titView addSubview:self.label];
}
#pragma mark - ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{   //确保滑动一页后才调用这个方法
    if((int)scrollView.contentOffset.x % (int)SW != 0){
        return;
    }
    
    int i =  scrollView.contentOffset.x/SW;
    
    //当图片显示最后一页时
    if (self.pc.numberOfPages+1 == i) {
        self.pc.currentPage = 0;
        scrollView.contentOffset = CGPointMake(SW, 0);
    }
    
    //偏移到第一页
    else if (i == 0) {
        self.pc.currentPage = self.pc.numberOfPages-1;
        scrollView.contentOffset = CGPointMake((self.pc.numberOfPages)*SW, 0);
    }
    //正常情况
    else{
        self.pc.currentPage = i-1;
    }
}

//结束缓冲时调用的方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self setupTimer];
}
//用户开始拖拽时调用的方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //计时器停止
    [self.timer invalidate];
}



#pragma mark - Tiemer方法
-(void)setupTimer
{
    //自动滚动
   
    self.timer=[NSTimer timerWithTimeInterval:self.interval target:self selector:@selector(TimerAction)userInfo:nil repeats:YES];
    // NSRunLoop就是APP本身的计时器
    NSRunLoop*loop=[NSRunLoop mainRunLoop];
    [loop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

-(void)TimerAction{
    
    //往下一页走
    self.pc.currentPage++;
    [self.sc setContentOffset:CGPointMake(self.sc.contentOffset.x+SW, 0) animated:YES];
}
#pragma mark - 手势
-(void)TapGes
{
    //单击
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GestureFuction:)];
    
    //点击次数
    self.tap.numberOfTapsRequired = 1;
    
}
-(void)LongGes
{
    //Long 长按手势
    self.longp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(GestureFuction:)];
    //触发时间
    self.longp.minimumPressDuration = 3;
}

-(void)GestureFuction:(UITapGestureRecognizer *)tap{
    self.action(self.pc.currentPage);
}

//UIScrollView中添加可视化生成的Controller

@end
