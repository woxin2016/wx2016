//
//  WXTURLFeedOBJ.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLFeedData.h"

typedef enum {
    WXT_UrlFeed_Type_LoadBalance = 0,
    WXT_UrlFeed_Type_Recharge,
    WXT_UrlFeed_Type_Sign,
    WXT_UrlFeed_Type_Login,
    WXT_UrlFeed_Type_LosinMessage,
    WXT_UrlFeed_Type_Regist,
    WXT_UrlFeed_Type_FetchPwd,
    WXT_UrlFeed_Type_GainNum,
    WXT_UrlFeed_Type_Version,
    WXT_UrlFeed_Type_Call,
    WXT_UrlFeed_Type_HungUp,
    WXT_UrlFeed_Type_ResetPwd,
    
    WXT_UrlFeed_Type_NewMall_UserAddress,
    WXT_UrlFeed_Type_New_LoadUserBonus,
    WXT_UrlFeed_Type_New_Code,
    WXT_UrlFeed_Type_New_ResetNewPwd,
    WXT_UrlFeed_Type_New_AboutShop,
    WXT_UrlFeed_Type_New_Version,
    WXT_UrlFeed_Type_New_Balance,
    WXT_UrlFeed_Type_New_XNBBalance,
    WXT_UrlFeed_Type_New_XNBOrderID,
    WXT_UrlFeed_Type_New_JPushMessageInfo,
    WXT_UrlFeed_Type_New_Call,
    WXT_UrlFeed_Type_New_Sign,
    WXT_UrlFeed_Type_New_PersonalInfo,
    WXT_UrlFeed_Type_New_Recharge,
    WXT_UrlFeed_Type_New_Wechat,
    WXT_UrlFeed_Type_New_RechargeList,
    WXT_UrlFeed_Type_New_LoadJPushMessage,
    WXT_UrlFeed_Type_New_SharedSucceed,
    WXT_UrlFeed_Type_New_UpdateUserHeader,
    WXT_UrlFeed_Type_New_LoadUserHeader,
    WXT_UrlFeed_Type_New_UpdapaOrderID,
    WXT_UrlFeed_Type_New_UserLoginShopInfo,
    WXT_UrlFeed_Type_UserQuestion,
    
    //发现
    WXT_UrlFeed_Type_New_FindData,
    WXT_UrlFeed_Type_New_ShareInfo,
    WXT_UrlFeed_Type_New_ShareCutInfo,
    //红包
    WXT_UrlFeed_Type_New_UserBonus,
    WXT_UrlFeed_Type_New_GainBonus,
    //订单
    WXT_UrlFeed_Type_Home_OrderList,
    WXT_UrlFeed_Type_New_MakeOrder,
    WXT_UrlFeed_Type_New_MakeLimitOrder,
    WXT_UrlFeed_Type_New_CancelOrder,
    WXT_UrlFeed_Type_New_CompleteOrder,
    WXT_UrlFeed_Type_Home_OrderEvaluate,
    //首页,
    WXT_UrlFeed_Type_NewMall_TopImg,
    WXT_UrlFeed_Type_NewMall_Recommond,
    WXT_UrlFeed_Type_NewMall_Surprise,
    WXT_UrlFeed_Type_New_LoadClassifyData,
    WXT_UrlFeed_Type_New_LoadClassifyGoodsList,
    WXT_UrlFeed_Type_New_LoadLimitGoods,
    WXT_UrlFeed_Type_New_ChangeSeller,
    WXT_UrlFeed_Type_New_Classify,
    //商品详情
    WXT_UrlFeed_Type_Home_GoodsInfo,
    WXT_UrlFeed_Type_Home_LimitGoodsInfo,
    WXT_UrlFeed_Type_NewMall_ImgAndText,
    WXT_UrlFeed_Type_New_SearchCarriageMoney,
    //收货地址
    WXT_UrlFeed_Type_New_CheckAreaVersion,
    WXT_UrlFeed_Type_New_LoadAreaData,
    WXT_UrlFeed_Type_NewMall_NewUserAddress,
    WXT_UrlFeed_Type_NewMall_ShoppingCart,
    //提成
    WXT_UrlFeed_Type_New_LoadMyClientInfo,
    WXT_UrlFeed_Type_New_LoadUserAliAccount,
    WXT_UrlFeed_Type_New_LoadMyClientPerson,
    WXT_UrlFeed_Type_New_LoadMyCutInfo,
    WXT_UrlFeed_Type_New_JuniorList,
    WXT_UrlFeed_Type_New_UserCutSource,
    WXT_UrlFeed_Type_New_ApplyAliMoney,
    WXT_UrlFeed_Type_New_SubmitUserAliAcount,
    WXT_UrlFeed_Type_New_LoadAliRecordList,
    // 搜索商品或者商店
    WXT_UrlFeed_Type_New_SearchGoodsOrShop,
    //抽奖
    WXT_UrlFeed_Type_New_SharkNumber,
    WXT_UrlFeed_Type_New_LuckyGoodsList,
    WXT_UrlFeed_Type_New_LuckyShark,
    WXT_UrlFeed_Type_New_LuckyGoodsInfo,
    WXT_UrlFeed_Type_New_LuckyMakeOrder,
    WXT_UrlFeed_Type_New_LuckyOrderList,
    WXT_UrlFeed_Type_New_LuckyTimes,
    
    //收藏
    WXT_UrlFeed_Type_New_PayAttention,
    
    //云票
    WXT_UrlFeed_Type_New_RechargeCt,  //云票充值
    WXT_UrlFeed_Type_New_UserCTRecord,
    WXT_UrlFeed_Type_New_MoreMoneyInfo,
    WXT_UrlFeed_Type_New_UserMoneyForm,  //现金组成
    WXT_UrlFeed_Type_New_UserMoneyInfo,
    //云票兑换
    WXT_UrlFeed_Type_VirtualGoods,
    WXT_UrlFeed_Type_VirtualGoodsInfo,
    WXT_UrlFeed_Type_VirtualOrder,
    WXT_UrlFeed_Type_VirtualOrderList,
    WXT_UrlFeed_Type_VirtualCanCelOrder,
    WXT_UrlFeed_Type_VirtualConfirmOrder,
    
    
    WXT_UrlFeed_Type_Invalid,
}WXT_UrlFeed_Type;

@interface WXTURLFeedOBJ : NSObject
+ (WXTURLFeedOBJ*)sharedURLFeedOBJ;
- (NSString*)rootURL:(WXT_UrlFeed_Type)type;
- (NSString*)urlRequestParamFrom:(NSDictionary*)dic;
@end

typedef enum{
    WXT_HttpMethod_Get = 0, //GET
    WXT_HttpMethod_Post,  //POST
}WXT_HttpMethod;

#define K_URLFeedOBJ_Data_Code @"error"
#define K_URLFeedOBJ_Data_ErrorDesc @"msg"
#define K_URLFeedOBJ_Data_Content @"data"
