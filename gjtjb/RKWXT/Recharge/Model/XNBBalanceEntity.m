//
//  XNBBalanceEntity.m
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "XNBBalanceEntity.h"

@implementation XNBBalanceEntity
+ (instancetype)xnbBalanceEntityWithDict:(NSDictionary*)dict{
    XNBBalanceEntity *entity = [[XNBBalanceEntity alloc]init];
    entity.xnb = [dict[@"xnb_1"] intValue];
    entity.rmb = [dict[@"rmb"] intValue];
    entity.monery = [dict[@"amount"] intValue];
    return entity;
}
@end
