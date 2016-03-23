//
//  DropdownMenu.m
//  RKWXT
//
//  Created by app on 16/3/21.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "DropdownMenu.h"
#import "UIViewAdditions.h"

@interface DropdownMenu ()
//背景图片
@property (nonatomic,strong)UIImageView *contenterview;
@end

@implementation DropdownMenu

- (UIImageView*)contenterview{
    if (_contenterview == nil) {
        //创建一个imageview
        UIImageView *dropdownMenu = [[UIImageView alloc]init];
        dropdownMenu.image = [UIImage imageNamed:@"searchTopAcc.png"];
        dropdownMenu.userInteractionEnabled = YES;
        [self addSubview:dropdownMenu];
        _contenterview = dropdownMenu;
    }
    return _contenterview;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //清楚自身颜色
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

+ (instancetype)menu{
    return [[self alloc]init];
}

//显示
- (void)show:(UIView*)view{
    //获取最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    //设置frame
    self.frame = window.bounds;
    
    self.contenterview.Y = CGRectGetMaxY(view.frame);
    self.contenterview.X = view.centerX;
    self.contenterview.size = CGSizeMake(20, 10);
    
    //通知外界  显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWithDidShow:)]) {
        [self.delegate dropdownMenuWithDidShow:self];
    }
}



- (void)setContent:(UIView *)content{
    _content = content;
    
    content.centerX = self.contenterview.centerX;
    content.Y = CGRectGetMaxY(self.contenterview.frame);
    
    [self addSubview:content];
}

- (void)setContentViewController:(UIViewController *)contentViewController{
    _contentViewController = contentViewController;
    self.content = contentViewController.view;
    
}

//监听点击 移除萌版
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self disMiss];
}

//隐藏
- (void)disMiss{
    [self removeFromSuperview];
    
    //通知外界 哥们要消失了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWithDidDismiss:)]) {
        [self.delegate dropdownMenuWithDidDismiss:self];
    }
}


@end
