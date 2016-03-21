//
//  DropdownMenu.h
//  RKWXT
//
//  Created by app on 16/3/21.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropdownMenu;
@protocol IWDropdownMenuDelegate <NSObject>

@optional
- (void)dropdownMenuWithDidDismiss:(DropdownMenu*)menu;
- (void)dropdownMenuWithDidShow:(DropdownMenu *)menu;

@end

@interface DropdownMenu : UIView

//显示在containerview上的view  内容
@property (nonatomic,strong)UIView *content;
//显示在containerview上的view  内容
@property (nonatomic,strong)UIViewController *contentViewController;
//代理
@property (nonatomic,weak)id<IWDropdownMenuDelegate> delegate;

//创建
+ (instancetype)menu;

//显示
- (void)show:(UIView*)view;

//删除
- (void)disMiss;

//监听点击 移除萌版
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
