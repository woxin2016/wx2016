//
//  WXTURLFeedOBJ.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTURLFeedOBJ.h"

@implementation WXTURLFeedOBJ

+ (WXTURLFeedOBJ*)sharedURLFeedOBJ{
    static dispatch_once_t onceToken;
    static WXTURLFeedOBJ *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WXTURLFeedOBJ alloc] init];
    });
    return sharedInstance;
}

- (NSString*)rootURL:(WXT_UrlFeed_Type)type{
    NSString *url = nil;
    NSString *rootURL = [NSString stringWithFormat:@"https://api.67call.com/agent/call_api.php"];
    NSString *newRootUrl = [NSString stringWithFormat:@"%@wx3api",WXTBaseUrl];   //商城模块
    switch (type) {
        case WXT_UrlFeed_Type_LoadBalance:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Recharge:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Sign:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Login:
            url = @"/app_login.php";
            break;
        case WXT_UrlFeed_Type_Regist:
            url = @"/app_register.php";
            break;
        case WXT_UrlFeed_Type_FetchPwd:
            url = @"";
            break;
        case WXT_UrlFeed_Type_GainNum:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Version:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Call:
            url = @"";
            break;
        case WXT_UrlFeed_Type_HungUp:
            url = @"";
            break;
        case WXT_UrlFeed_Type_ResetPwd:
            url = @"/app_modify_pwd.php";
            break;
        case WXT_UrlFeed_Type_NewMall_UserAddress:
            url = @"/get_user_address.php";
            break;
        case WXT_UrlFeed_Type_New_LoadUserBonus:
            url = @"/get_user_red_packet.php";
            break;
        case WXT_UrlFeed_Type_New_Code:
            url = @"/get_rcode.php";
            break;
        case WXT_UrlFeed_Type_New_ResetNewPwd:
            url = @"/app_reset_pwd.php";
            break;
        case WXT_UrlFeed_Type_New_AboutShop:
            url = @"/get_seller_detail.php";
            break;
        case WXT_UrlFeed_Type_New_Version:
            url = @"/app_version.php";
            break;
        case WXT_UrlFeed_Type_New_Balance:
            url = @"/app_balance.php";
            break;
        case WXT_UrlFeed_Type_New_JPushMessageInfo:
            url = @"/get_message_detail.php";
            break;
        case WXT_UrlFeed_Type_New_Call:
            url = @"/app_cb.php";
            break;
        case WXT_UrlFeed_Type_New_Sign:
            url = @"/app_sign_in.php";
            break;
        case WXT_UrlFeed_Type_New_PersonalInfo:
            url = @"/get_user_info.php";
            break;
        case WXT_UrlFeed_Type_New_Recharge:
            url = @"/app_recharge.php";
            break;
        case WXT_UrlFeed_Type_New_Wechat:
            url = @"/get_prepay_id.php";
            break;
        case WXT_UrlFeed_Type_New_RechargeList:
            url = @"/insert_recharge_order.php";
            break;
        case WXT_UrlFeed_Type_New_LoadJPushMessage:
            url = @"/get_new_message.php";
            break;
        case WXT_UrlFeed_Type_New_SharedSucceed:
            url = @"/get_share_award.php";
            break;
        case WXT_UrlFeed_Type_New_UpdateUserHeader:
            url = @"/app_upload_userpic.php";
            break;
        case WXT_UrlFeed_Type_New_LoadUserHeader:
            url = @"/get_user_pic.php";
            break;
        case WXT_UrlFeed_Type_New_UpdapaOrderID:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Home_LMorderList:
            url = @"/get_sellerunion_order_info.php";
            break;
        case WXT_UrlFeed_Type_New_UserBonus:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_GainBonus:
            url = @"";
            break;
        default:
            break;
    }
    NSString *compURL = [NSString stringWithFormat:@"%@%@",rootURL,url];
    if(![url isEqualToString:@""]){
        return [NSString stringWithFormat:@"%@%@",newRootUrl,url];
    }
    return compURL;
}

- (NSString*)urlRequestParamFrom:(NSDictionary*)dic{
    NSArray *keys = [dic allKeys];
    if ([keys count] == 0){
        return nil;
    }
    
    NSMutableString *mutString = [NSMutableString string];
    for (NSString *key in keys){
        id value = [dic objectForKey:key];
        if (!value){
            KFLog_Normal(YES, @"无效的参数 key = %@",key);
            continue;
        }
        if ([keys indexOfObject:key] != 0){
            [mutString appendString:@"&"];
        }
        [mutString appendFormat:@"%@=%@",key,value];
    }
    return mutString;
}

@end
