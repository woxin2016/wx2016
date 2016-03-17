//
//  ShoppingCartView.m
//  RKWXT
//
//  Created by app on 16/3/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ShoppingCartView.h"
#import "NewShopPingCartModel.h"
#import "ShoppingCartModel.h"

#import "GoodsInfoDef.h"

@interface ShoppingCartView ()
{
    UIImageView *_unreadNumberImgV;
    UILabel *_unreadLabel;
    NSInteger _number;
}
@end

@implementation ShoppingCartView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImage *btnImg = [UIImage imageNamed:@"Shopping.png"];
        
        WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0,frame.size.width, frame.size.height);
        [leftBtn setImage:btnImg forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftBtn.titleLabel setFont:WXFont(10.0)];
        [leftBtn addTarget:self action:@selector(goShoppingVC) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
//        CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(leftBtn.titleLabel.bounds), CGRectGetMidY(leftBtn.titleLabel.bounds));
//        CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(leftBtn.imageView.bounds));
//        CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(leftBtn.bounds)-CGRectGetMidY(leftBtn.titleLabel.bounds));
//        CGPoint startImageViewCenter = leftBtn.imageView.center;
//        CGPoint startTitleLabelCenter = leftBtn.titleLabel.center;
//        CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
//        CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
//        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imageEdgeInsetsLeft, 40/3, imageEdgeInsetsRight);
//        CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
//        CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
//        leftBtn.titleEdgeInsets = UIEdgeInsetsMake(40*2/3-5, titleEdgeInsetsLeft, 0, titleEdgeInsetsRight);
        
        UIImage *image = [UIImage imageNamed:@"unreadBg.png"];
        CGSize imgSize = image.size;
        _unreadNumberImgV = [[UIImageView alloc] initWithImage:image];
        CGRect unreadViewRect = CGRectMake(imgSize.width * 0.3 + frame.size.width / 2.0, frame.size.height/2.0-imgSize.height*0.3-10, imgSize.width, imgSize.height);
        [_unreadNumberImgV setFrame:unreadViewRect];
        [leftBtn addSubview:_unreadNumberImgV];
        [_unreadNumberImgV setHidden:_number];
        
        _unreadLabel = [[WXUILabel alloc] initWithFrame:_unreadNumberImgV.frame];
        [_unreadLabel setFont:[UIFont systemFontOfSize:9.0]];
        [_unreadLabel setTextColor:[UIColor whiteColor]];
         _unreadLabel.textAlignment = NSTextAlignmentCenter;
        [leftBtn addSubview:_unreadLabel];
        
        _number = [[NewShopPingCartModel shopPingCartModelAlloc] unreadShopNumber];
        [_unreadLabel setText:[NSString stringWithFormat:@"%d",_number]];
        [_unreadLabel setHidden:_number == 0];
        [_unreadNumberImgV setHidden:_number == 0];
    
        
        
        [self addOBS];
    }
    return self;
}

- (void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inComeBuyShop:) name:D_Notification_AddGoodsShoppingCart_Succeed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteOneGoodsSucceed:) name:D_Notification_DeleteOneGoodsInShoppingCartList_Succeed object:nil];
}

- (void)inComeBuyShop:(NSNotification*)notification{
    NSString *goodsID = [[notification.object objectForKey:@"data"] objectForKey:@"cart_id"];
    [[NewShopPingCartModel shopPingCartModelAlloc] setUnreadGoodsID:[goodsID integerValue] structrue:ShopPingCartModel_Structure_Add];
    [self setUnreadNumber:[[NewShopPingCartModel shopPingCartModelAlloc] unreadShopNumber]];
}

- (void)deleteOneGoodsSucceed:(NSNotification*)notification{
    NSString *goodsID = notification.object;
    [[NewShopPingCartModel shopPingCartModelAlloc] setUnreadGoodsID:[goodsID integerValue] structrue:ShopPingCartModel_Structure_Remove];
    [self setUnreadNumber:[[NewShopPingCartModel shopPingCartModelAlloc] unreadShopNumber]];
}

- (void)setUnreadNumber:(NSInteger)number{
        _number = number;
    
        NSString *text = [NSString stringWithFormat:@"%d",(int)number];
    
        [_unreadLabel setText:text];
        _unreadLabel.center = _unreadNumberImgV.center;
    
        [_unreadLabel setHidden:_number == 0];
        [_unreadNumberImgV setHidden:_number == 0];
}

- (void)goShoppingVC{
    if (_delegate && [_delegate respondsToSelector:@selector(shoppingCartViewInShoppingVC)]) {
        [_delegate shoppingCartViewInShoppingVC];
    }
}

@end