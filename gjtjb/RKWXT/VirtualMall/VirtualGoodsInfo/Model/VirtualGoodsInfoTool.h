//
//  VirtualGoodsInfoTool.h
//  RKWXT
//
//  Created by app on 16/4/7.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VirtualGoodsInfoModel,VirtualOrderInfoEntity,VirtualStockGoodsView;
@interface VirtualGoodsInfoTool : NSObject
@property (nonatomic,assign)NSInteger red;
@property (nonatomic,assign)NSInteger cut;
@property (nonatomic,assign)NSInteger postage;
+ (instancetype)virtualGoodsInfoAlloc;
- (BOOL)GoodsInfoToolWithModel:(VirtualGoodsInfoModel*)model;

// 可以兑换
+ (NSString*)canUseVirtual:(VirtualGoodsInfoModel*)model;

// 已经兑换
+ (NSString*)pastVirtual:(VirtualGoodsInfoModel*)model;

// 设置返现金额
+ (CGFloat)backMoney:(VirtualGoodsInfoModel*)model;

//所需云票
+ (int)xnb:(VirtualGoodsInfoModel*)model;

//价格
+ (CGFloat)goodsPrice:(VirtualGoodsInfoModel*)model;

// 返回订单信息
+ (VirtualOrderInfoEntity*)buyGoodsInfo:(VirtualStockGoodsView*)view;
@end
