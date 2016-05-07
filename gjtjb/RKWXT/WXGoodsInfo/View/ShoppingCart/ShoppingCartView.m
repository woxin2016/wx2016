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
    ShoppingCartModel *model;
    WXUIButton *_leftBtn;
}
@end

@implementation ShoppingCartView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImage *btnImg = [UIImage imageNamed:@"Shopping.png"];
        
        _leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 0,frame.size.width, frame.size.height);
        [_leftBtn setImage:btnImg forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftBtn.titleLabel setFont:WXFont(10.0)];
        [_leftBtn addTarget:self action:@selector(goShoppingVC) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        
        
        UIImage *image = [UIImage imageNamed:@"unreadBg.png"];
        CGSize imgSize = image.size;
        _unreadNumberImgV = [[UIImageView alloc] initWithImage:image];
        CGFloat X = _leftBtn.frame.size.width / 2 + imgSize.width / 4.0;
        CGFloat Y = - (imgSize.height / 4);
        CGRect unreadViewRect = CGRectMake(X,Y, imgSize.width, imgSize.height);
        [_unreadNumberImgV setFrame:unreadViewRect];
        [_leftBtn addSubview:_unreadNumberImgV];
        [_unreadNumberImgV setHidden:_number];
        
        
        _unreadLabel = [[WXUILabel alloc] initWithFrame:_unreadNumberImgV.frame];
        [_unreadLabel setFont:[UIFont systemFontOfSize:9.0]];
        [_unreadLabel setTextColor:[UIColor whiteColor]];
         _unreadLabel.textAlignment = NSTextAlignmentCenter;
        [_leftBtn addSubview:_unreadLabel];
        
        [self addOBS];
    }
    return self;
}

- (void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadShoppingCartCount) name:D_Notification_LoadShoppingCartList_Failed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inComeBuyShop) name:D_Notification_AddGoodsShoppingCart_Succeed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookShoppingCartCount) name:D_Notification_DeleteOneGoodsInShoppingCartList_Succeed object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookShoppingCartCount) name:D_Notification_LoadShoppingCartList_Succeed object:nil];
}

- (void)lookShoppingCartCount{
     [self setUnreadNumber:[ShoppingCartModel shareShoppingCartModel].shoppingCartListArr.count];
}

- (void)loadShoppingCartCount{
    [self setUnreadNumber:0];
}

- (void)inComeBuyShop{
    [self searchShoppingCartNumber];
}

- (void)deleteOneGoodsSucceed:(NSNotification*)notification{
     [self searchShoppingCartNumber];
}

- (void)searchShoppingCartNumber{
    [[ShoppingCartModel shareShoppingCartModel] loadShoppingCartList];
    _number = [ShoppingCartModel shareShoppingCartModel].shoppingCartListArr.count;
    [_unreadLabel setText:[NSString stringWithFormat:@"%d",_number]];
    [_unreadLabel setHidden:_number == 0];
    
    [_unreadNumberImgV setHidden:_number == 0];
}

- (void)setUnreadNumber:(NSInteger)number{
    _number = number;
    [_unreadLabel setHidden:_number == 0];
    [_unreadNumberImgV setHidden:_number == 0];
    
    if (number == 0) return;
    
    NSString *text = [NSString stringWithFormat:@"%d",(int)number];
    
    [_unreadLabel setText:text];
//    _unreadLabel.center = _unreadNumberImgV.center;
    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)goShoppingVC{
    if (_delegate && [_delegate respondsToSelector:@selector(shoppingCartViewInShoppingVC)]) {
        [_delegate shoppingCartViewInShoppingVC];
    }
}

- (void)replaceBtnImage:(NSString*)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    [_leftBtn setImage:image forState:UIControlStateNormal];
}

@end
