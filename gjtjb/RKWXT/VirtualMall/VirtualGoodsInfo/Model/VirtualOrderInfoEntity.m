//
//  VirtualOrderInfoEntity.m
//  RKWXT
//
//  Created by app on 16/4/9.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualOrderInfoEntity.h"

@implementation VirtualOrderInfoEntity
+ (instancetype)shareVirtualOrderAlloc{
  static dispatch_once_t onceUser;
    static VirtualOrderInfoEntity *entity;
    dispatch_once(&onceUser, ^{
        entity = [[VirtualOrderInfoEntity alloc]init];
    });
    return entity;
}

+ (instancetype)virtualOrderInfoEntityWithDict:(NSDictionary*)dict{
    VirtualOrderInfoEntity *order = [[VirtualOrderInfoEntity alloc]init];
    order.orderID = dict[@"order_id"];
    order.payMoney = [dict[@"total_fee"] floatValue];
    return order;
}


@end
