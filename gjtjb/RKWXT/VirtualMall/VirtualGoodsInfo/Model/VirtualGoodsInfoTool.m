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
    
    if ([model.stockArr count] > 0) {
        for(VirtualGoodsInfoEntity *entity in model.goodsInfoArr){
            goodsInfoEntity = entity;
            self.postage = goodsInfoEntity.postage;
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
    CGFloat can = 0.0;
    if ([model.stockArr count] == 0) return nil;
    
    for (VirtualGoodsInfoEntity *entity in model.stockArr) {
        can += entity.canVirtual;
    }
    return [NSString stringWithFormat:@"%.2f",can];
}

// 已经兑换
+ (NSString*)pastVirtual:(VirtualGoodsInfoModel*)model{
    if ([model.goodsInfoArr count] == 0) return nil;
    VirtualGoodsInfoEntity *entity = model.goodsInfoArr[0];
    return [NSString stringWithFormat:@"%.2f",entity.pastVirtual];
}

+ (VirtualOrderInfoEntity*)buyGoodsInfo:(NewGoodsStockView*)model{
    VirtualOrderInfoEntity *entity = [[VirtualOrderInfoEntity alloc] init];
    
    return entity;
}

@end
