//
//  virtualOrderListEntity.m
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "virtualOrderListEntity.h"

@implementation virtualOrderListEntity

+(virtualOrderListEntity*)virtualOrderListEntityWidthDic:(NSDictionary*)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWidthDic:dic];
}

-(id)initWidthDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *address = [dic objectForKey:@"address"];
        [self setAddress:address];
        
        NSString *username = [dic objectForKey:@"consignee"];
        [self setUserName:username];
        
        NSString *goodsName = [dic objectForKey:@"goods_name"];
        [self setGoods_name:goodsName];
        
        NSString *goodsImg = [dic objectForKey:@"goods_img"];
        [self setGoods_img:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,goodsImg]];
        
        NSInteger goods_id = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoods_id:goods_id];
        
        NSInteger stockID = [[dic objectForKey:@"goods_stock_id"] integerValue];
        [self setStock_id:stockID];
        
        NSString *stockName = [dic objectForKey:@"goods_stock_name"];
        [self setStockName:stockName];
        
        NSInteger isPay = [[dic objectForKey:@"is_payment"] integerValue];
        [self setPay_status:isPay];
        
        NSInteger isSend = [[dic objectForKey:@"is_shipments"] integerValue];
        [self setSend_status:isSend];
        
        NSInteger isComplete = [[dic objectForKey:@"order_status"] integerValue];
        [self setOrder_status:isComplete];
        
        NSInteger lott = [[dic objectForKey:@"lottery_id"] integerValue];
        [self setLottery_id:lott];
        
        CGFloat monery = [[dic objectForKey:@"total_fee"] floatValue];
        [self setMonery:monery];
        
        CGFloat parketPrice = [[dic objectForKey:@"market_price"] floatValue];
        [self setMarket_price:parketPrice];
        
        
        
        NSInteger orderID = [[dic objectForKey:@"order_id"] integerValue];
        [self setOrder_id:orderID];
        
        NSInteger sendTime = [[dic objectForKey:@"shipments_time"] integerValue];
        [self setSend_time:sendTime];
        
        NSString *sendType = [dic objectForKey:@"shipments_type"];
        [self setSend_type:sendType];
        
        NSString *phone = [dic objectForKey:@"telephone"];
        [self setUserPhone:phone];
        
        NSInteger makeOrderTime = [[dic objectForKey:@"add_time"] integerValue];
        [self setMakeOrderTime:makeOrderTime];
        
        NSString *number = [dic objectForKey:@"tracking_number"];
        [self setSend_number:number];
        
        int xnb = [[dic objectForKey:@"xnb_1"] intValue];
        [self setXnb:xnb];
        
        CGFloat price = [[dic objectForKey:@"goods_price"] floatValue];
        [self setGoodsPrice:price];
        
        CGFloat postage = [[dic objectForKey:@"postage"] floatValue];
        [self setPosgate:postage];
        
        NSString *userMessage = [dic objectForKey:@"remark"];
        [self setUserMessage:userMessage];
    }
    return self;
}
@end
