//
//  HomeLimitGoodsEntity.h
//  RKWXT
//
//  Created by app on 16/3/10.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeLimitGoodsEntity : NSObject
@property (nonatomic,assign)NSInteger startTime;
@property (nonatomic,assign)NSInteger endTime;
@property (nonatomic,strong)NSMutableArray *goodsArray;
+ (instancetype)homeLimitGoodsWithDic:(NSDictionary*)dic;
@end
