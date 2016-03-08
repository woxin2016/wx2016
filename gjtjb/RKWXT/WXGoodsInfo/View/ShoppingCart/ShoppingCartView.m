//
//  ShoppingCartView.m
//  RKWXT
//
//  Created by app on 16/3/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ShoppingCartView.h"

@interface ShoppingCartView ()
{
    UIImageView *_unreadNumberImgV;
    UILabel *_unreadLabel;
}
@end

@implementation ShoppingCartView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImage *btnImg = [UIImage imageNamed:@"GoodsInfoCartImg.png"];
        CGSize btnSize = btnImg.size;
        
        WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = frame;
        [leftBtn setImage:btnImg forState:UIControlStateNormal];
//        [leftBtn setTitle:@"购物车" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftBtn.titleLabel setFont:WXFont(10.0)];
        [leftBtn addTarget:self action:@selector(goShoppingVC) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
        CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(leftBtn.titleLabel.bounds), CGRectGetMidY(leftBtn.titleLabel.bounds));
        CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(leftBtn.imageView.bounds));
        CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(leftBtn.bounds)-CGRectGetMidY(leftBtn.titleLabel.bounds));
        CGPoint startImageViewCenter = leftBtn.imageView.center;
        CGPoint startTitleLabelCenter = leftBtn.titleLabel.center;
        CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
        CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imageEdgeInsetsLeft, 40/3, imageEdgeInsetsRight);
        CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
        CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
        leftBtn.titleEdgeInsets = UIEdgeInsetsMake(40*2/3-5, titleEdgeInsetsLeft, 0, titleEdgeInsetsRight);
        
        UIImage *image = [UIImage imageNamed:@"unreadBg.png"];
        CGSize imgSize = image.size;
        _unreadNumberImgV = [[UIImageView alloc] initWithImage:image];
        CGRect unreadViewRect = CGRectMake(-imgSize.width*0.3 + (frame.size.width-btnSize.width)/2.0-5, (frame.size.height-btnSize.height)/2.0-imgSize.height*0.3-10, imgSize.width, imgSize.height);
        [_unreadNumberImgV setFrame:unreadViewRect];
        [leftBtn addSubview:_unreadNumberImgV];
        
        _unreadLabel = [[WXUILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [_unreadLabel setFont:[UIFont systemFontOfSize:9.0]];
        [_unreadLabel setTextColor:[UIColor whiteColor]];
        [_unreadNumberImgV addSubview:_unreadLabel];
    }
    return self;
}

- (void)goShoppingVC{
    if (_delegate && [_delegate respondsToSelector:@selector(shoppingCartViewInShoppingVC)]) {
        [_delegate shoppingCartViewInShoppingVC];
    }
}

@end
