//
//  LImitGoodsEntity.m
//  RKWXT
//
//  Created by app on 16/3/10.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "LImitGoodsEntity.h"

@implementation LImitGoodsEntity
+ (instancetype)limitGoodsEntityWithDict:(NSDictionary*)dic{
    LImitGoodsEntity *goods =[[LImitGoodsEntity alloc]init];
    goods.goodsID = [dic[@"goods_id"] integerValue];
    goods.goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,dic[@"goods_home_img"]];
    goods.goodsName = dic[@"goods_name"];
    goods.goodsPrice = dic[@"max_goods_price"];
    goods.goodsLowPic = dic[@"min_seckill_price"];
    return goods;
}
@end
