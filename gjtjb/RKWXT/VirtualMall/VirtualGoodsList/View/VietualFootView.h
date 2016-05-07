//
//  VietualFootView.h
//  RKWXT
//
//  Created by app on 16/5/3.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VietualFootViewDelegate;
@interface VietualFootView : UIView
@property (nonatomic,weak)id<VietualFootViewDelegate> delegate;
- (void)footbtnWithTitle:(NSString*)title  andIsStart:(BOOL)start;
@end


@protocol VietualFootViewDelegate <NSObject>
- (void)vietualFootViewClickFootBtn;
@end