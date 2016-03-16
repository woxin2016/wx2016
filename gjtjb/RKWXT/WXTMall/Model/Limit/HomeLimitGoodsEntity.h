//
//  HomeLimitGoodsEntity.h
//  RKWXT
//
//  Created by app on 16/3/10.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeLimitGoodsEntity : NSObject
@property (nonatomic,copy)NSString *startTime;
@property (nonatomic,copy)NSString *endTime;
@property (nonatomic,assign)NSInteger sckillID;
@property (nonatomic,strong)NSMutableArray *goodsArray;
+ (instancetype)homeLimitGoodsWithDic:(NSDictionary*)dic;
@end
