//
//  VirtualGoods.h
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#ifndef RKWXT_VirtualGoods_h
#define RKWXT_VirtualGoods_h


#define Size self.bounds.size
#define DownViewHeight (44)
#define TopNavigationViewHeight (64)
#define TopNavigationViewHeight (64)
#define ExplainCellHeight (80)
#define DseCellHeight (125)
enum{
    VirtualGoodsInfo_Section_TopImg = 0,
    VirtualGoodsInfo_Section_GoodsDesc,
    VirtualGoodsInfo_Section_Unstable,
    VirtualGoodsInfo_Section_Integral,
    VirtualGoodsInfo_Section_Explain,
    VirtualGoodsInfo_Section_GoodsInfo,
    VirtualGoodsInfo_Section_GoodsBaseData,

    VirtualGoodsInfo_Section_Invalid,
};


#import "VirtualGoodsInfoModel.h"
#import "VirtualGoodsInfoTool.h"
#import "VirtualGoodsInfoEntity.h"
#import "NewImageZoomView.h"
#import "WXRemotionImgBtn.h"
#import "VirtualStockGoodsView.h"
#import "NewGoodsStockView.h"


#import "FindCommonVC.h"
#import "VirtualSubGoodsInfoWebVC.h"
#import "CallBackVC.h"
#import "VirtualGoodsOrderVC.h"



#import "VirtualTopImgCell.h"
#import "VietualInfoDesCell.h"
#import "VirtualInfoBDCell.h"
#import "VirtualInfoDownCell.h"
#import "VirtualInfoDesExchangeCell.h"
#import "VirtualInfoExplainCell.h"
#import "VirtualInfoIntegralCell.h"
#import "VirtualGoodsRedCutCell.h"




#import "VirtualGoodsListVC.h"


#endif
