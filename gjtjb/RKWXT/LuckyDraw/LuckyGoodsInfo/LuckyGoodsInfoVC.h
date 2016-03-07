//
//  LuckyGoodsInfoVC.h
//  RKWXT
//
//  Created by SHB on 15/8/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"
@class LuckySharkEntity;

typedef enum{
    LuckyGoodsInfo_Type_Shark = 0, //展示抽奖详情
    LuckyGoodsInfo_Type_Show,   //抽奖后展示详情
}LuckyGoodsInfo_Type;

@interface LuckyGoodsInfoVC : WXUIViewController
@property (nonatomic,strong) LuckySharkEntity *luckyEnt;
@property (nonatomic,assign) LuckyGoodsInfo_Type showType;

@end
