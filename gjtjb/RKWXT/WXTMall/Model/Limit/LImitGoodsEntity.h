//
//  LImitGoodsEntity.h
//  RKWXT
//
//  Created by app on 16/3/10.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LImitGoodsEntity : NSObject
@property (nonatomic,strong)NSString *goodsName;
@property (nonatomic,assign)NSInteger goodsID;
@property (nonatomic,strong)NSString *goodsImg;
@property (nonatomic,strong)NSString *goodsPrice;
@property (nonatomic,strong)NSString *goodsLowPic;
+ (instancetype)limitGoodsEntityWithDict:(NSDictionary*)dic;
@end
