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
@property (nonatomic,assign)CGFloat xnbPrice;
@end
