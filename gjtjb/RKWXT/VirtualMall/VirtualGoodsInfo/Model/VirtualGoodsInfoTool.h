//
//  VirtualGoodsInfoTool.h
//  RKWXT
//
//  Created by app on 16/4/7.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VirtualGoodsInfoModel,VirtualOrderInfoEntity,NewGoodsStockView;
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

// 返回订单信息
+ (VirtualOrderInfoEntity*)buyGoodsInfo:(NewGoodsStockView*)model;
@end
