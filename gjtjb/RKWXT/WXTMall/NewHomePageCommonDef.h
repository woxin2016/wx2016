//
//  NewHomePageCommonDef.h
//  RKWXT
//
//  Created by SHB on 15/5/29.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_NewHomePageCommonDef_h
#define RKWXT_NewHomePageCommonDef_h

#define Size self.bounds.size
#define T_HomePageTopImgHeight          IPHONE_SCREEN_WIDTH/2
#define T_HomePageBaseFunctionHeight    (132)
#define T_HomePageLimitBuyHeight        (180)
#define T_HomePageTextSectionHeight     (39)
#define T_HomePageCommonImgHeight       (80)
#define T_HomePageRecommendHeight       (225)
#define T_HomePageGuessInfoHeight       (225)
#define T_HomePageClassifyInfoHeight    (88)

#define BigTextFont   (13.0)
#define TextFont      (14.0)
#define SmallTextFont (12.0)

#define BigTextColor   (0x282828)
#define SmallTextColor (0xa5a3a3)
#define HomePageBGColor (0xffffff)

#define LimitBuyShow    (3.5)
#define RecommendShow   (2)
#define ClassifyShow    (4)
#define GuessInfoShow   (2)

//section
enum{
    T_HomePage_TopImg = 0,     //顶部图片
    T_HomePage_BaseFunction,   //基础功能模块
    T_HomePage_LimitBuyTitle,  //秒杀
    T_HomePage_LimitBuyInfo,   //
    T_HomePage_CenterImg,      //中间图片
    T_HomePage_RecomendTitle,  //为我推荐
    T_HomePage_RecomendInfo,   //
    T_HomePage_DownImg,        //底部图片
    T_HomePage_ClassifyTitle,  //分类
    T_HomePage_ClassifyInfo,
    T_HomePage_GuessTitle,     //猜你喜欢
    T_HomePage_GuessInfo,      //
    
    T_HomePage_Invalid,
};

#import "WXTMallListWebVC.h"
#import "WXSysMsgUnreadV.h"
#import "MJRefresh.h"
#import "MailShareView.h"
#import "WXGoodsInfoVC.h"
#import "CloudTicketListVC.h"

#import "WXHomeTopGoodCell.h"
#import "WXHomeBaseFunctionCell.h"
#import "HomeLimitBuyTitleCell.h"
#import "HomeLimitBuyCell.h"
#import "HomeRecommendInfoCell.h"
#import "HomeGuessInfoCell.h"
#import "HomeNewGuessInfoCell.h"
#import "HomeClassifyTitleCell.h"
#import "HomePageCommonImgCell.h"
#import "HomeClassifyInfoCell.h"

#import "WXWeiXinOBJ.h"
#import <TencentOpenAPI/QQApiInterface.h>

#import "JPushMessageCenterVC.h"
#import "UserBonusVC.h"
#import "SignViewController.h"
#import "LuckyShakeVC.h"
#import "GoodsClassifyVC.h"
#import "NewUserCutVC.h"
#import "FindCommonVC.h"
#import "WXLimitGoodsInfoVC.h"
#import "SellerChangeVC.h"

#import "NewHomePageModel.h"
#import "HomePageSurpEntity.h"
#import "HomePageRecEntity.h"
#import "LImitGoodsEntity.h"
#import "HomeLimitGoodsEntity.h"
#import "HomePageClassifyEntity.h"

#pragma mark 导航跳转
enum{
    HomePageJump_Type_GoodsInfo = 1,    //商品详情
    HomePageJump_Type_Catagary,         //分类列表
    HomePageJump_Type_MessageCenter,    //消息中心
    HomePageJump_Type_MessageInfo,      //消息详情
    HomePageJump_Type_UserBonus,        //红包
    HomePageJump_Type_BusinessAlliance, //商家联盟
    HomePageJump_Type_Web,              //跳转网页
    HomePageJump_Type_None,             //不跳转
    
    HomePageJump_Type_Invalid
};

#endif
