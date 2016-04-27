//
//  VirtualGoodsInfoEntity.m
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualGoodsInfoEntity.h"

@implementation VirtualGoodsInfoEntity

//商品详情
+(VirtualGoodsInfoEntity *)initGoodsInfoEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initGoodsInfoDic:dic];
}

-(id)initGoodsInfoDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *homeImg = [dic objectForKey:@"goods_home_img"];
        [self setHomeImg:homeImg];
        
        NSString *topImg = [dic objectForKey:@"goods_icarousel_img"];
        [self setGoodsImg:topImg];
        
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoodsID:goodsID];
        
        NSString *goodsName = [dic objectForKey:@"goods_name"];
        [self setGoodsName:goodsName];
        
//        NSInteger postage = [[dic objectForKey:@"is_postage"] integerValue];
//        [self setPostage:postage];
        
        CGFloat marketPrice = [[dic objectForKey:@"market_price"] floatValue];
        [self setMarketPrice:marketPrice];
        
        
        NSString *merName = [dic objectForKey:@"meterage_name"];
        [self setMeterageName:merName];
        
        
        NSInteger shopId = [[dic objectForKey:@"shop_id"] integerValue];
        [self setGoodshop_id:shopId];
        
        
        int pastVirtual = [[dic objectForKey:@"end_exchange"] intValue];
        [self setPastVirtual:pastVirtual];
        
        CGFloat postageVirtual = [[dic objectForKey:@"postage"] floatValue];
        [self setPostageVirtual:postageVirtual];
        
        NSString *virtualImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,[dic objectForKey:@"goods_icarousel_img"]];
        [self setVirtualImg:virtualImg];
        
    }
    return self;
}

//所属商家
+(VirtualGoodsInfoEntity *)initSellerInfoEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initSellerData:dic];
}

-(id)initSellerData:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *address = [dic objectForKey:@"address"];
        [self setSellerAddress:address];
        
        
        NSString *sellername = [dic objectForKey:@"seller_name"];
        [self setSellerName:sellername];
        
        NSInteger sellerID = [[dic objectForKey:@"seller_id"] integerValue];
        [self setSellerID:sellerID];
        
        NSString *sellerPhone = [dic objectForKey:@"telephone"];
        [self setSellerPhone:sellerPhone];
    }
    return self;
}

//基础属性
+(VirtualGoodsInfoEntity *)initBaseAttrDataEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initBaseAttrData:dic];
}

-(id)initBaseAttrData:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *attrName = [dic objectForKey:@"attr_name"];
        [self setAttrName:attrName];
        
        NSString *attrValue = [dic objectForKey:@"attr_value"];
        [self setAttrValue:attrValue];
    }
    return self;
}

//评价
+(VirtualGoodsInfoEntity *)initEvaluteDataEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initEvaluteData:dic];
}

-(id)initEvaluteData:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *content = [dic objectForKey:@"content"];
        [self setContent:content];
        
        NSInteger addTime = [[dic objectForKey:@"add_time"] integerValue];
        [self setAddTime:addTime];
        
        NSString *nickName = [dic objectForKey:@"nickname"];
        [self setNickName:nickName];
        
        NSString *phone = [dic objectForKey:@"phone"];
        [self setUserPhone:phone];
        
        NSString *pic = [dic objectForKey:@"pic"];
        [self setUserHeadImg:pic];
    }
    return self;
}

//推荐商家
+(VirtualGoodsInfoEntity *)initOtherShopEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initOtherShop:dic];
}

-(id)initOtherShop:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *address = [dic objectForKey:@"address"];
        [self setShopAddress:address];
        
        
        NSInteger shopID = [[dic objectForKey:@"seller_id"] integerValue];
        [self setShopID:shopID];
        
        NSString *shopName = [dic objectForKey:@"shop_name"];
        [self setShopName:shopName];
    }
    return self;
}

//库存
+(VirtualGoodsInfoEntity *)initStockDataEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initStockData:dic];
}

-(id)initStockData:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger cut = [[dic objectForKey:@"divide"] integerValue];
        [self setUserCut:cut];
        
        NSInteger number = [[dic objectForKey:@"goods_number"] integerValue];
        [self setStockNum:number];
        
        CGFloat goodsPrice = [[dic objectForKey:@"goods_price"] floatValue];
        [self setStockPrice:goodsPrice];
        
        NSInteger stockId = [[dic objectForKey:@"goods_stock_id"] integerValue];
        [self setStockID:stockId];
        
        NSString *name = [dic objectForKey:@"goods_stock_name"];
        [self setStockName:name];
        
        NSInteger red = [[dic objectForKey:@"is_use_red"] integerValue];
        [self setRedPacket:red];
        
        int canVirtual = [[dic objectForKey:@"goods_number"] intValue];
        [self setCanVirtual:canVirtual];
        
        BOOL isDefult = [[dic objectForKey:@"is_default"] boolValue];
        [self setIsDefault:isDefult];
        
        CGFloat backMoney = [[dic objectForKey:@"back_money"] floatValue];
        [self setBackMoney:backMoney];
        
        int xnb = [[dic objectForKey:@"xnb_1"] intValue];
        [self setXnb:xnb];
        
        CGFloat goods_price = [[dic objectForKey:@"goods_price"] floatValue];
        [self setGoodsPrice:goods_price];
    }
    return self;
}


@end
