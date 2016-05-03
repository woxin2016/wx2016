//
//  VietualHeardView.m
//  RKWXT
//
//  Created by app on 16/4/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VietualHeardView.h"

@interface VietualHeardView ()
@property (nonatomic,strong)UIButton *seleBtn;
@property (nonatomic,strong)NSArray *titArray;
@property (nonatomic,strong)UIView *didView;
@property (nonatomic,strong)UIView *boView;
@end

@implementation VietualHeardView



- (NSArray*)titArray{
    if (!_titArray) {
        _titArray = @[@"免费兑换",@"品牌兑换"];
    }
    return _titArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat width = (frame.size.width / 2) - 0.5;
        CGFloat height = frame.size.height;
        for (int i = 0; i < self.titArray.count; i++) {
            CGFloat btnX = width *i;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnX, 0, width, height);
            btn.tag = i;
            [btn setTitle:self.titArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            btn.titleLabel.font = WXFont(15.0);
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:btn];
            
            UIView *marView = [[UIView alloc]initWithFrame:CGRectMake(width,8, 0.5, height - 16)];
            marView.backgroundColor = [UIColor grayColor];
            [self addSubview:marView];
            
            if (i == 0) {
                [self clickBtn:btn];
            }
        }
        
        self.boView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 0.5, self.width, 0.5)];
        self.boView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.boView];
        
        CGFloat didX = (width - (width / 2)) / 2;
        self.didView = [[UIView alloc]initWithFrame:CGRectMake(didX, frame.size.height - 1, width / 2, 1)];
        self.didView.backgroundColor = [UIColor redColor];
        [self addSubview:self.didView];
    }
    return self;
}

- (void)clickBtn:(UIButton*)btn{
    
  
    
    if (self.seleBtn == btn) return;
    
    self.seleBtn = btn;
   
   
    __block VietualHeardView *blockSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        blockSelf.didView.centerX = btn.centerX;
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(vietualHeardViewClickBtnTag:)]) {
        [_delegate vietualHeardViewClickBtnTag:btn.tag];
    }
}

-(void)setSeleBtn:(UIButton *)seleBtn{
    seleBtn.selected = YES;
    self.seleBtn.selected = NO;
    _seleBtn = seleBtn;
}



@end
