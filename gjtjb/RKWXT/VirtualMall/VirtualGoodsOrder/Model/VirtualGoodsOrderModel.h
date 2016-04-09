//
//  VirtualGoodsOrderModel.h
//  RKWXT
//
//  Created by app on 16/4/7.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VirtualGoodsInfoEntity;
typedef enum{
    VirtualGoodsOrderType_Default,
    VirtualGoodsOrderType_Store,
    VirtualGoodsOrderType_Exchange,
}VirtualGoodsOrderType;

@protocol VirtualGoodsOrderModelDelegate <NSObject>
- (void)virtualGoodsOrderSuccend;
- (void)virtualGoodsOrderFailed:(NSString*)errorMsg;
@end
@interface VirtualGoodsOrderModel : NSObject
@property (nonatomic,weak)id <VirtualGoodsOrderModelDelegate> delegate;
- (void)submitOrdersVitrtualWithType:(VirtualGoodsOrderType)type goodsID:(NSInteger)goodsID goodsPrice:(NSString*)goodsPrice xnb:(NSInteger)xnb backMoner:(CGFloat)backMoney postage:(CGFloat)postage;
- (void)submitOrdersVitrtualWithType:(VirtualGoodsOrderType)type goodsInfo:(VirtualGoodsInfoEntity*)goodsInfo;

@end
