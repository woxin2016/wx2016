//
//  VirtualGoodsInfoVC.h
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "NLMainViewController.h"

typedef enum{
    VirtualGoodsType_Default = 0,
    VirtualGoodsType_Store,
    VirtualGoodsType_Exchange
}VirtualGoodsType;

@interface VirtualGoodsInfoVC : NLMainViewController
@property (nonatomic,assign)NSInteger goodsID;
@property (nonatomic,assign)VirtualGoodsType type;
@end
