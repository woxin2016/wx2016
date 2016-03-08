//
//  GoodsLineTool.h
//  RKWXT
//
//  Created by app on 16/3/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol GoodsLineToolDelegate;

@interface GoodsLineTool : NSObject
@property (nonatomic, assign) id<GoodsLineToolDelegate>delegate;
@property (nonatomic, retain) UIView *showingView;

+ (GoodsLineTool *)sharedTool;

- (void)throwObject:(UIView *)obj from:(CGPoint)start to:(CGPoint)end;

@end

@protocol GoodsLineToolDelegate <NSObject>

/**
 *  抛物线结束的回调
 */
- (void)animationDidFinish;

@end