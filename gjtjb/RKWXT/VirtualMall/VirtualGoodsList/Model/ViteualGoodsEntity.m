//
//  ViteualGoodsEntity.m
//  RKWXT
//
//  Created by app on 16/4/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ViteualGoodsEntity.h"

@implementation ViteualGoodsEntity

/*
 "goods_id":"10000298",
 "goods_name":"兑换商品2",
 "goods_home_img":"20160408/20160408095236_738813.png",
 "shop_price":"20.00",
 "market_price":"10.00",
 "xnb_1":"10.00",
 "back_money":"3.00"
 */
+ (instancetype)viteualGoodsEntityWithDic:(NSDictionary*)dic{
    if (!dic) return nil;
    ViteualGoodsEntity *entity = [[ViteualGoodsEntity alloc]init];
    entity.goodsIcon = dic[@"goods_home_img"];
    entity.goodsID = [dic[@"goods_id"] integerValue];
    entity.goodsName = dic[@"goods_name"];
    entity.goodsPrice = [dic[@"goods_price"] floatValue];
    entity.marPrice = [dic[@"market_price"] floatValue];
    entity.backMoney = [dic[@"back_money"] floatValue];
    entity.xnb = [dic[@"xnb_1"] intValue];
    return entity;
}
@end
