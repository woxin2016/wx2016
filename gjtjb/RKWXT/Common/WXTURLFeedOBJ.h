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
    
    //红包
    WXT_UrlFeed_Type_New_UserBonus,
    WXT_UrlFeed_Type_New_GainBonus,
    //订单
    WXT_UrlFeed_Type_Home_LMorderList,
    
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
