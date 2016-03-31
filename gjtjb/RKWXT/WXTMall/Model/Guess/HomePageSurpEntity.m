//
//  HomePageSurpEntity.m
//  RKWXT
//
//  Created by SHB on 16/1/15.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomePageSurpEntity.h"

@implementation HomePageSurpEntity

+(HomePageSurpEntity*)homePageSurpEntityWithDictionary:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoods_id:goodsID];
        
        NSString *name = [dic objectForKey:@"goods_name"];
        [self setGoods_name:name];
        
        NSString *imgUrl = [dic objectForKey:@"goods_home_img"];
        [self setHome_img:imgUrl];
        
        CGFloat shop_price = [[dic objectForKey:@"shop_price"] floatValue];
        [self setShop_price:shop_price];
        
        NSInteger hot = [[dic objectForKey:@"hot"] integerValue];
        [self setHotNum:hot];
        
        NSInteger store = [[dic objectForKey:@"stores"] integerValue];
        [self setLikeNum:store];
    }
    return self;
}

@end
