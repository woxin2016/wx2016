//
//  WaitPayOrderHandleCell.m
//  RKWXT
//
//  Created by SHB on 16/1/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WaitPayOrderHandleCell.h"
#import "AllOrderListEntity.h"

@interface WaitPayOrderHandleCell(){
    WXUIButton *leftBtn;
    WXUIButton *rightBtn;
}
@end

@implementation WaitPayOrderHandleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat btnWidth = 56;
        CGFloat btnHeight = 24;
        rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnWidth, (WaitPayOrderHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [rightBtn setHidden:YES];
        [rightBtn setBackgroundColor:WXColorWithInteger(0xff9c00)];
//        [rightBtn setBorderRadian:3.0 width:1.0 color:[UIColor clearColor]];
        [rightBtn.titleLabel setFont:WXFont(10.0)];
        [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:rightBtn];
        
        leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-2*(xOffset+btnWidth), (WaitPayOrderHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [leftBtn setHidden:YES];
        [leftBtn setBackgroundColor:WXColorWithInteger(0xff9c00)];
//        [leftBtn setBorderRadian:3.0 width:1.0 color:[UIColor clearColor]];
        [leftBtn.titleLabel setFont:WXFont(10.0)];
        [leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:leftBtn];
    }
    return self;
}

-(void)load{
    [self userHandleBtnState];
}

-(void)userHandleBtnState{
    AllOrderListEntity *entity = self.cellInfo;
    if(entity.payType == Order_PayType_WaitPay && entity.orderState == Order_State_Normal){
        [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [leftBtn setHidden:NO];
        [rightBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [rightBtn setHidden:NO];
    }
}

-(void)rightBtnClicked{
    AllOrderListEntity *entity = self.cellInfo;
    if(entity.payType == Order_PayType_WaitPay && entity.orderState == Order_State_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userPayOrder:)]){
            [_delegate userPayOrder:entity];
        }
    }
}

-(void)leftBtnClicked{
    AllOrderListEntity *entity = self.cellInfo;
    if(entity.payType == Order_PayType_WaitPay && entity.orderState == Order_State_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userCancelOrder:)]){
            [_delegate userCancelOrder:entity];
        }
    }
}

@end
