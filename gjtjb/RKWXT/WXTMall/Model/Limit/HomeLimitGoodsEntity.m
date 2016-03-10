//
//  HomeLimitGoodsEntity.m
//  RKWXT
//
//  Created by app on 16/3/10.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "HomeLimitGoodsEntity.h"
#import "LImitGoodsEntity.h"

@implementation HomeLimitGoodsEntity
+ (instancetype)homeLimitGoodsWithDic:(NSDictionary *)dic{
    HomeLimitGoodsEntity *limitGoods = [[HomeLimitGoodsEntity alloc]init];
    limitGoods.startTime = [dic[@"begin_time"] integerValue];
    limitGoods.endTime = [dic[@"end_time"] integerValue];
    for (NSDictionary *goods in dic[@"seckill_goods"]) {
        LImitGoodsEntity *goodsEntity = [LImitGoodsEntity limitGoodsEntityWithDict:goods];
        [limitGoods.goodsArray addObject:goodsEntity];
    }
    return limitGoods;
}

- (NSMutableArray*)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}
@end
