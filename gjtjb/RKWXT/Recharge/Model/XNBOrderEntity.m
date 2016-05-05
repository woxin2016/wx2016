//
//  XNBOrderEntity.m
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "XNBOrderEntity.h"

@implementation XNBOrderEntity
+ (instancetype)xnbOrderEntityWithDic:(NSDictionary*)dic{
    XNBOrderEntity *order = [[XNBOrderEntity alloc]init];
    order.price = [dic[@"total_fee"] floatValue];
    order.xnb = [dic[@"xnb_1"] floatValue];
    order.orderID = dic[@"order_id"];
    return order;
}
@end
