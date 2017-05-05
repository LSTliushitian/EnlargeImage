//
//  LSTPhotoDisplayView.m
//  哈林教育
//
//  Created by qqqq on 16/4/21.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "LSTPhotoDisplayView.h"
//屏幕宽高
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface LSTPhotoDisplayView ()<UIScrollViewDelegate>
/**
 1. 滚动视图
 */
@property (nonatomic) UIScrollView *scrollView;

/**
 2. 获取当前视图
 */
@property (nonatomic) UIView * currentView;

@end

@implementation LSTPhotoDisplayView
static LSTPhotoDisplayView * photoDisplayView = nil;
+ (void) displayPhotoesWithImageArray:(NSArray *)imageArr isImageUrl:(BOOL)isImageUrl currentIndex:(NSInteger)index {
    if (!imageArr.count) {
        return;
    }
    if (!photoDisplayView) {
        photoDisplayView = [[LSTPhotoDisplayView alloc] init];
    }
    
    [photoDisplayView createMainViewUI];
    [photoDisplayView displayPhotoesWithImageArray:imageArr isImageUrl:isImageUrl currentIndex:index];
    
}

#pragma mark - 创建主界面UI
- (void)createMainViewUI
{
    //1. 获取当前窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //2. 修改视图区域为全屏
    self.frame = window.rootViewController.view.bounds;
    //3. 当前视图添加到窗口
    [window addSubview:self];
    
    /**
     1. 滚动视图
     */
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:_scrollView];
    [_scrollView setDelegate:self];
    _scrollView.tag = 3000;
    
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnTapAction)];
    [_scrollView addGestureRecognizer:tap];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView.tag == 3000) {
        return nil;
    }

    return _currentView;
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.tag == 3000) {
        return;
    }
    
    //获取当前放大倍数，及当前的imageView
    CGFloat scale = scrollView.zoomScale;
    UIImageView * imageView = (UIImageView *)_currentView;
    UIImage * image = imageView.image;
    //计算图片及展示区域的宽高比例
    CGFloat imageScale = image.size.width / image.size.height;
    CGFloat displayScale = scrollView.bounds.size.width / scrollView.bounds.size.height;
    //修改imageView的尺寸
    CGRect rect = scrollView.frame;
    rect.size.width = WIDTH;
    rect.size.height = HEIGHT;
    scrollView.frame = rect;
    //根据图片更改相关尺寸
    if (displayScale > imageScale) {
        //图片偏高
        scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT*scale);
        imageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT*scale);
        
    } else {
        //图片偏宽
        scrollView.contentSize = CGSizeMake(WIDTH*scale, HEIGHT);
        imageView.frame = CGRectMake(0, 0, WIDTH*scale, HEIGHT);
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 3000) {
#pragma mark - 放大滑动回来时，需要恢复原样则打开注释代码
//        UIScrollView * displayView = (UIScrollView *)_currentView.superview;
//        displayView.zoomScale = 1.0;
//        _currentView.frame = displayView.bounds;
        //获取当前视图
        CGFloat xxx = scrollView.contentOffset.x;
        _currentView = [scrollView viewWithTag:(xxx/WIDTH)+1000];
        
    }
}

#pragma mark - 展示图片
- (void) displayPhotoesWithImageArray:(NSArray *)imageArr isImageUrl:(BOOL)isImageUrl currentIndex:(NSInteger)index
{
    for (int i = 0; i < imageArr.count; i++) {
        
        // 1. 图片展示区域
        UIScrollView *displayView = [[UIScrollView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        displayView.backgroundColor = [UIColor blackColor];
        [_scrollView addSubview:displayView];
        [displayView setDelegate:self];
        [displayView setMinimumZoomScale:1.0f];
        
        // 2. 图片展示区域
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:displayView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [imageView setTag:1000+i];
        [displayView addSubview:imageView];
        
        // 获得当前展示视图
        if (i == index) {
            _currentView = imageView;
        }
        
        // 3. 展示图片
        if (isImageUrl) {
            // 3.1 展示网络图片
//            [imageView sd_setImageWithURL:[imageArr objectAtIndex:i] placeholderImage:[UIImage imageNamed:@"defaultImg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                if (!image) {
//                    image = [UIImage imageNamed:@"defaultImg"];
//                }
//                
//                // 4. 获取图片及宽高比例
//                CGFloat imageScale = image.size.width / image.size.height;
//                CGFloat displayScale = displayView.bounds.size.width / displayView.bounds.size.height;
//                if (displayScale > imageScale) {
//                    //图片偏高
//                    [displayView setMaximumZoomScale:WIDTH/(HEIGHT*imageScale)];
//                    
//                } else {
//                    //图片偏宽
//                    [displayView setMaximumZoomScale:HEIGHT/WIDTH*imageScale];
//                }
//            }];
        } else {
            // 3.2 展示本地图片
            UIImage *image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
            imageView.image = image;
            
            // 4. 获取图片及宽高比例
            CGFloat imageScale = image.size.width / image.size.height;
            CGFloat displayScale = displayView.bounds.size.width / displayView.bounds.size.height;
            if (displayScale > imageScale) {
                //图片偏高
                [displayView setMaximumZoomScale:WIDTH/(HEIGHT*imageScale)];
                
            } else {
                //图片偏宽
                [displayView setMaximumZoomScale:HEIGHT/WIDTH*imageScale];
            }
        }
        
    }
    
    // 5. 修改背景滚动视图的滚动区域及偏移量
    _scrollView.contentSize = CGSizeMake(WIDTH * imageArr.count, HEIGHT);
    //偏移量修改到指定位置
    [_scrollView setContentOffset:CGPointMake(WIDTH *index, 0)];
}

#pragma mark - 点击页面退出
- (void) returnTapAction
{
    [self removeFromSuperview];
}

@end
