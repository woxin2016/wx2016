//
//  VirtualGoodsOrderVC.h
//  RKWXT
//
//  Created by app on 16/4/7.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    virtualParOrderType_Default,
    virtualParOrderType_Store,   // 兑换商城
    virtualParOrderType_Exchange  // 品牌兑换
}virtualParOrderType;

typedef enum{
    VirtualOrderType_PayOrder,
    VirtualOrderType_LookOrderStatus,
}VirtualOrderType;

@class VirtualOrderInfoEntity;
@interface VirtualGoodsOrderVC : WXUIViewController
@property (nonatomic,strong)VirtualOrderInfoEntity *virtualOrder;
@property (nonatomic,assign)virtualParOrderType type;
@property (nonatomic,assign)VirtualOrderType orderType;
@end
