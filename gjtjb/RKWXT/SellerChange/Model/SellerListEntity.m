//
//  SellerListEntity.m
//  RKWXT
//
//  Created by SHB on 16/3/29.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "SellerListEntity.h"

@implementation SellerListEntity

+(SellerListEntity*)initSellerListEntityWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *address = [dic objectForKey:@"address"];
        [self setAddress:address];
        
        NSInteger sellerID = [[dic objectForKey:@"seller_id"] integerValue];
        [self setSellerID:sellerID];
        
        NSString *sellerName = [dic objectForKey:@"seller_name"];
        [self setSellerName:sellerName];
        
        NSString *logoImg = [dic objectForKey:@"seller_logo"];
        [self setLogoImg:logoImg];
        
        NSInteger shopID = [[dic objectForKey:@"shop_id"] integerValue];
        [self setShopID:shopID];
        
        NSString *shopName = [dic objectForKey:@"shop_name"];
        [self setShopName:shopName];
    }
    return self;
}

@end
