//
//  ViewController.m
//  lunbotu
//
//  Created by Gioures on 2023/1/30.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView4;
@property (weak, nonatomic) IBOutlet UIView *contentView3;
@property (weak, nonatomic) IBOutlet UIView *contentView2;
@property (weak, nonatomic) IBOutlet UIView *contentView1;
@property (weak, nonatomic) IBOutlet UIView *contentView0;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong) NSTimer *__nullable timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentOffset=CGPointMake(self.scrollView.frame.size.width, 0);

    
    self.pageControl.numberOfPages= 3;
    self.pageControl.currentPage=0;

    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    //添加到runloop中
    NSRunLoop *runloop=[NSRunLoop currentRunLoop];
    [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    

//    [self.pageControl setValue:[UIImage imageNamed:@"icon_lunbo_changgun"] forKey:@"currentPageImage"];
//    [self.pageControl setValue:[UIImage imageNamed:@"icon_lunbo_yuandian"] forKey:@"pageImage"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX=scrollView.contentOffset.x;
    offsetX+=scrollView.frame.size.width*0.5;
    
    //因为最前面还有一个imgView
    int page=offsetX/scrollView.frame.size.width-1;
    self.pageControl.currentPage=page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    self.timer=nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];

    //优先级 设置到当前的runloop中
    NSRunLoop *runloop=[NSRunLoop currentRunLoop];
    [runloop addTimer:self.timer forMode: NSRunLoopCommonModes];
}

-(void)scrollImage{
             
    NSInteger page=[self.pageControl currentPage];
    page++;
    CGFloat offsetX= page * self.scrollView.frame.size.width+self.scrollView.frame.size.width;
     
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"contentOffset"]) {
        //[change objectForKey:NSKeyValueChangeNewKey] 是一个对象
        CGPoint offset= [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        //当划到3后面的1时
        if(offset.x >= self.scrollView.contentSize.width-self.scrollView.frame.size.width) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
            self.pageControl.currentPage=0;
            
        }
        //当划到1前面的3时
        else if(offset.x <= 0) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-2*self.scrollView.frame.size.width, 0)];
            self.pageControl.currentPage=self.pageControl.numberOfPages-1;
            
        }
        
    }
}
@end

