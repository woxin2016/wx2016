//
//  PersonalOrderInfoCell.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PersonalOrderInfoCell.h"
#import "ShoppingCartView.h"

@interface PersonalOrderInfoCell () <ShoppingCartViewDelegate>

@end

@implementation PersonalOrderInfoCell

/*
 shoppingCartBtn = [[ShoppingCartView alloc]initWithFrame:CGRectMake(self.bounds.size.width-35, TopNavigationViewHeight-35, 25, 25)];
 shoppingCartBtn.delegate = self;
 [shoppingCartBtn searchShoppingCartNumber];
 [self.view addSubview:shoppingCartBtn];
 */

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 30;
        CGFloat btnWidth = 68;
        CGFloat btnHeight = 50;
        WXUIButton *cartBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        cartBtn.frame = CGRectMake(xOffset, (PersonalOrderInfoCellHeight-50)/2 + 3, btnWidth, btnHeight);
        [cartBtn addTarget:self action:@selector(toMyShoppingCart) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cartBtn];
        ShoppingCartView *cartBtn1 = [[ShoppingCartView alloc]initWithFrame:CGRectMake(35/2, 0, btnWidth, 25)];
        cartBtn1.delegate = self;
        [cartBtn1 searchShoppingCartNumber];
        [cartBtn1 replaceBtnImage:@"ShoppingCartImg.png"];
        [cartBtn addSubview:cartBtn1];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(35/2, cartBtn1.bottom , btnWidth, 20)];
        label.text = @"购物车";
        label.font = WXFont(13.0);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = WXColorWithInteger(0x707070);
        [cartBtn addSubview:label];
        
        
        
        xOffset += btnWidth+xOffset;
        WXUIButton *waitPayBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        waitPayBtn.frame = CGRectMake(xOffset, (PersonalOrderInfoCellHeight-btnHeight)/2+3, btnWidth, btnHeight);
        [waitPayBtn setImage:[UIImage imageNamed:@"WaitingPayImg.png"] forState:UIControlStateNormal];
        [waitPayBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, 35, btnHeight/2, 0))];
        [waitPayBtn setTitle:@"待付款" forState:UIControlStateNormal];
        [waitPayBtn setTitleEdgeInsets:(UIEdgeInsetsMake(20, 0, 0, 0))];
        [waitPayBtn setTitleColor:WXColorWithInteger(0x707070) forState:UIControlStateNormal];
        [waitPayBtn.titleLabel setFont:WXFont(13.0)];
        [waitPayBtn addTarget:self action:@selector(waitPay) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:waitPayBtn];
        
        xOffset += btnWidth+30;
        WXUIButton *waitRecBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        waitRecBtn.frame = CGRectMake(xOffset, (PersonalOrderInfoCellHeight-btnHeight)/2+3, btnWidth, btnHeight);
        [waitRecBtn setImage:[UIImage imageNamed:@"WaitGainGoods.png"] forState:UIControlStateNormal];
        [waitRecBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, 32, btnHeight/2, 0))];
        [waitRecBtn setTitle:@"待收货" forState:UIControlStateNormal];
        [waitRecBtn setTitleEdgeInsets:(UIEdgeInsetsMake(20, 0, 0, 0))];
        [waitRecBtn setTitleColor:WXColorWithInteger(0x707070) forState:UIControlStateNormal];
        [waitRecBtn.titleLabel setFont:WXFont(13.0)];
        [waitRecBtn addTarget:self action:@selector(waitReceive) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:waitRecBtn];
    }
    return self;
}

-(void)load{

}

-(void)toMyShoppingCart{
    if(_delegate && [_delegate respondsToSelector:@selector(personalInfoToShoppingCart)]){
        [_delegate personalInfoToShoppingCart];
    }
}

-(void)waitPay{
    if(_delegate && [_delegate respondsToSelector:@selector(personalInfoToWaitPayOrderList)]){
        [_delegate personalInfoToWaitPayOrderList];
    }
}

-(void)waitReceive{
    if(_delegate && [_delegate respondsToSelector:@selector(personalInfoToWaitReceiveOrderList)]){
        [_delegate personalInfoToWaitReceiveOrderList];
    }
}

- (void)shoppingCartViewInShoppingVC{
    if(_delegate && [_delegate respondsToSelector:@selector(personalInfoToShoppingCart)]){
        [_delegate personalInfoToShoppingCart];
    }
}

@end
