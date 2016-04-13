//
//  ViteualGoodsEntity.h
//  RKWXT
//
//  Created by app on 16/4/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViteualGoodsEntity : NSObject
@property (nonatomic,copy)NSString *goodsName;
@property (nonatomic,assign)CGFloat goodsPrice;
@property (nonatomic,assign)CGFloat marPrice;
@property (nonatomic,assign)CGFloat backMoney;
@property (nonatomic,copy)NSString *goodsIcon;
@property (nonatomic,assign)NSInteger goodsID;
@property (nonatomic,assign)int xnb;
+ (instancetype)viteualGoodsEntityWithDic:(NSDictionary*)dic;
@end
