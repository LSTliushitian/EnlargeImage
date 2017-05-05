//
//  LSTPhotoDisplayView.h
//  哈林教育
//
//  Created by qqqq on 16/4/21.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSTPhotoDisplayView : UIView

/**
 展示图片
 */
+ (void) displayPhotoesWithImageArray:(NSArray *)imageArr isImageUrl:(BOOL)isImageUrl currentIndex:(NSInteger)index;

@end
