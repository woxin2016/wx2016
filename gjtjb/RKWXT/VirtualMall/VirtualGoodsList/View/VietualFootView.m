//
//  VietualFootView.m
//  RKWXT
//
//  Created by app on 16/5/3.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VietualFootView.h"

@interface VietualFootView ()
{
    UIButton *_footBtn;
    UIActivityIndicatorView *_actiView;
}
@end

@implementation VietualFootView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat height = frame.size.height;
        UIView *view = [[UIView alloc]initWithFrame:frame];
        view.backgroundColor = RGB_COLOR(245, 245, 245);
        [self addSubview:view];
        view.center = self.center;
        
        _footBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, height)];
        [_footBtn addTarget:self action:@selector(clickFootBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_footBtn setTitle:@"加载更多" forState:UIControlStateNormal];
        _footBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_footBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [view addSubview:_footBtn];
        _footBtn.center = view.center;
        
        CGFloat actiW = 30;
        _actiView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _actiView.frame = CGRectMake(_footBtn.X - actiW, 0, actiW, height);
        [view addSubview:_actiView];
    }
    return self;
}

- (void)clickFootBtn:(UIButton*)btn{
     if ([btn.titleLabel.text isEqualToString:@"无更多"]) return;
    if (_delegate &&[_delegate respondsToSelector:@selector(vietualFootViewClickFootBtn)]) {
        [_delegate vietualFootViewClickFootBtn];
    }
}

-(void)footbtnWithTitle:(NSString *)title andIsStart:(BOOL)start{
    [_footBtn setTitle:title forState:UIControlStateNormal];
    
    if (start) {
        [_actiView startAnimating];
    }else{
        [_actiView stopAnimating];
    }
    [_actiView setHidesWhenStopped:YES];
}
@end
