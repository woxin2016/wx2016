//
//  WXGoodsInfoVC.h
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "NLMainViewController.h"

typedef enum{
    GoodsInfo_Normal = 0,
    GoodsInfo_LuckyGoods,
    GoodsInfo_LimitGoods,
}GoodsInfo_Type;

@interface WXGoodsInfoVC : NLMainViewController
@property (nonatomic,assign) NSInteger goodsId;
@property (nonatomic,assign)NSInteger sckillID;
@property (nonatomic,assign) GoodsInfo_Type  goodsInfo_type;
@end
