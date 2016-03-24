//
//  CollectionGoodsEntity.m
//  RKWXT
//
//  Created by app on 16/3/23.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "CollectionGoodsEntity.h"

@implementation CollectionGoodsEntity
+ (instancetype)collectionGoodsEntity:(NSDictionary *)dic{
    CollectionGoodsEntity *goods = [[CollectionGoodsEntity alloc]init];
    goods.homeImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,dic[@"goods_home_img"]];
    goods.goodsID = [dic[@"goods_id"] integerValue];
    goods.goodsName = dic[@"goods_name"];
    goods.shopPrice = [dic[@"shop_price"] floatValue];
    goods.marketPrice = [dic[@"market_price"] floatValue];
    goods.deleGoodsID = [dic[@"store_id"] integerValue];
    return goods;
}
@end
