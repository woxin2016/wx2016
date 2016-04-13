//
//  VirtualOrderInfoEntity.h
//  RKWXT
//
//  Created by app on 16/4/9.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VirtualGoodsInfoEntity;
@interface VirtualOrderInfoEntity : NSObject
@property (nonatomic,strong)VirtualGoodsInfoEntity *entity;
@property (nonatomic,assign)NSInteger buyNumber;
@property (nonatomic,assign)CGFloat goodsPrice;
@property (nonatomic,assign)CGFloat postage;
@property (nonatomic,assign)CGFloat backMoney;
@property (nonatomic,assign)NSInteger stockID;
@property (nonatomic,assign)int xnbPrice;
@property (nonatomic,strong) NSString *goodsImg;
@property (nonatomic,strong) NSString *stockName;
@property (nonatomic,strong) NSString *goodsName;

+ (instancetype)shareVirtualOrderAlloc;

//提交订单数据
@property (nonatomic,strong) NSString *orderID;
@property (nonatomic,assign) CGFloat payMoney;
+ (instancetype)virtualOrderInfoEntityWithDict:(NSDictionary*)dict;
@end
