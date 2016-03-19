//
//  WXLimitGoodsInfoVC.h
//  RKWXT
//
//  Created by app on 16/3/18.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "NLMainViewController.h"

typedef enum{
    LimitGoodsInfo_Normal = 0,
    LimitGoodsInfo_LuckyGoods,
    LimitGoodsInfo_LimitGoods,
}LimitGoodsInfo_Type;

@interface WXLimitGoodsInfoVC : NLMainViewController
@property (nonatomic,assign) NSInteger goodsId;
@property (nonatomic,assign) NSInteger sckillID;
@property (nonatomic,assign,getter=isBuyGoods)BOOL buyGoods;
@property (nonatomic,assign) LimitGoodsInfo_Type  LimitGoodsInfo_Type;
- (void)addGoodsid:(NSInteger)goodsID sckillID:(NSInteger)sckillID;
@end
