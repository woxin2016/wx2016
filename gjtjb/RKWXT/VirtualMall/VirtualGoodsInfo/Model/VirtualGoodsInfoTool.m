//
//  VirtualGoodsInfoTool.m
//  RKWXT
//
//  Created by app on 16/4/7.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualGoodsInfoTool.h"
#import "VirtualGoodsInfoEntity.h"
#import "VirtualGoodsInfoModel.h"
#import "VirtualOrderInfoEntity.h"
#import "VirtualStockGoodsView.h"



@implementation VirtualGoodsInfoTool
+ (instancetype)virtualGoodsInfoAlloc{
    static dispatch_once_t once;
    static VirtualGoodsInfoTool *tool = nil;
    dispatch_once(&once, ^{
        tool = [[VirtualGoodsInfoTool alloc]init];
    });
    return tool;
}


- (BOOL)GoodsInfoToolWithModel:(VirtualGoodsInfoModel*)model{
    VirtualGoodsInfoEntity * stockEntity , *goodsInfoEntity;
    if([model.stockArr count] > 0){
        for(VirtualGoodsInfoEntity *entity in model.stockArr){
            stockEntity = entity;
            self.red = entity.redPacket;
            self.cut = entity.userCut;
        }
    }
    
  
    if ((self.red != 0) || (self.cut != 0) || (self.postage != 0)) {
        return YES;
    }else{
        return NO;
    } 
}

// 可以兑换
+ (NSString*)canUseVirtual:(VirtualGoodsInfoModel*)model{
    int can = 0.0;
    if ([model.stockArr count] == 0) return nil;
    
    for (VirtualGoodsInfoEntity *entity in model.stockArr) {
        can += entity.canVirtual;
    }
    return [NSString stringWithFormat:@"%.d",can];
}

// 已经兑换
+ (NSString*)pastVirtual:(VirtualGoodsInfoModel*)model{
    if ([model.goodsInfoArr count] == 0) return nil;
    VirtualGoodsInfoEntity *entity = model.goodsInfoArr[0];
    return [NSString stringWithFormat:@"%.d",entity.pastVirtual];
}


+ (VirtualOrderInfoEntity*)buyGoodsInfo:(VirtualStockGoodsView*)view{
    return view.virtualOrder;
}


+ (CGFloat)backMoney:(VirtualGoodsInfoModel*)model{
    if ([model.stockArr count] == 0) return 0.0;
    CGFloat money = 0.0;
    for (VirtualGoodsInfoEntity *entity in model.stockArr) {
        if (entity.isDefault) {
            money =  entity.backMoney;
        }
    }
    return money;
}

+ (int)xnb:(VirtualGoodsInfoModel*)model{
    if ([model.stockArr count] == 0) return 0.0;
    int money = 0.0;
    for (VirtualGoodsInfoEntity *entity in model.stockArr) {
        if (entity.isDefault) {
            money =  entity.xnb;
        }
    }
    return money;
}
+ (CGFloat)goodsPrice:(VirtualGoodsInfoModel*)model{
    if ([model.stockArr count] == 0) return 0.0;
    CGFloat money = 0.0;
    for (VirtualGoodsInfoEntity *entity in model.stockArr) {
        if (entity.isDefault) {
            money =  entity.goodsPrice;
        }
    }
    return money;
}

@end
