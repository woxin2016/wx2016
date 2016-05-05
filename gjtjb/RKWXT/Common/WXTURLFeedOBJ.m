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
    NSString *newRootUrl = [NSString stringWithFormat:@"%@wx10api/V1",WXTBaseUrl];   //商城模块
    NSString *allUrl = nil;
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
            url = @"/login.php";
            break;
        case WXT_UrlFeed_Type_LosinMessage:
            url = @"/login_push.php";
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
            url = @"/hangup.php";
            break;
        case WXT_UrlFeed_Type_ResetPwd:
            url = @"/modify_pwd.php";
            break;
        case WXT_UrlFeed_Type_NewMall_UserAddress:
            url = @"/get_user_address.php";
            break;
        case WXT_UrlFeed_Type_New_LoadUserBonus:
            url = @"/user_red_packet.php";
            break;
        case WXT_UrlFeed_Type_New_Code:
            url = @"/get_rcode.php";
            break;
        case WXT_UrlFeed_Type_New_ResetNewPwd:
            url = @"/reset_pwd.php";
            break;
        case WXT_UrlFeed_Type_New_AboutShop:
            url = @"/get_seller_detail.php";
            break;
        case WXT_UrlFeed_Type_New_Version:
            url = @"/version.php";
            break;
        case WXT_UrlFeed_Type_New_Balance:
            url = @"/telephone_fare.php";
            break;
        case WXT_UrlFeed_Type_New_JPushMessageInfo:
            url = @"/get_message_detail.php";
            break;
        case WXT_UrlFeed_Type_New_Call:
            url = @"/callback.php";
            break;
        case WXT_UrlFeed_Type_New_Sign:
            url = @"/sgin_in_xnb.php";
            break;
        case WXT_UrlFeed_Type_New_PersonalInfo:
            url = @"/userinfo.php";
            break;
        case WXT_UrlFeed_Type_New_Recharge:
            url = @"/recharge.php";
            break;
        case WXT_UrlFeed_Type_UserQuestion:
            url = @"/question.php";
            break;
        case WXT_UrlFeed_Type_New_Wechat:
//            url = @"/get_prepay_id.php";
            allUrl = @"wx10order/wx10WeixinPay/app_prepay_id.php";
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
        case WXT_UrlFeed_Type_New_UserLoginShopInfo:
            url = @"/get_shoplist.php";
            break;
        case WXT_UrlFeed_Type_New_UpdateUserHeader:
            url = @"/app_upload_userpic.php";
            break;
        case WXT_UrlFeed_Type_New_LoadUserHeader:
            url = @"/get_user_pic.php";
            break;
        case WXT_UrlFeed_Type_New_UpdapaOrderID:
            url = @"/get_pay_status.php";
            break;
        case WXT_UrlFeed_Type_New_FindData:
            url = @"/discover.php";
            break;
        case WXT_UrlFeed_Type_New_ShareInfo:
            url = @"/app_share_info.php";
            break;
        case WXT_UrlFeed_Type_New_ShareCutInfo:
            url = @"/invite_info.php";
            break;
        case WXT_UrlFeed_Type_Home_OrderList:
            url = @"/order_list.php";
            break;
        case WXT_UrlFeed_Type_Home_OrderEvaluate:
            url = @"/order_evaluate.php";
            break;
        case WXT_UrlFeed_Type_New_UserBonus:
            url = @"/red_packet_list.php";
            break;
        case WXT_UrlFeed_Type_New_GainBonus:
            url = @"/receive_red_packet.php";
            break;
        case WXT_UrlFeed_Type_NewMall_TopImg:
            url = @"/top_images.php";
            break;
        case WXT_UrlFeed_Type_NewMall_Recommond:
            url = @"/home_recommend.php";
            break;
        case WXT_UrlFeed_Type_NewMall_Surprise:
            url = @"/home_youlike.php";
            break;
        case WXT_UrlFeed_Type_New_LoadClassifyData:
            url = @"/top_category.php";
            break;
        case WXT_UrlFeed_Type_New_LoadClassifyGoodsList:
            url = @"/category_goods.php";
            break;
        case WXT_UrlFeed_Type_New_LoadLimitGoods:
            url = @"/seckills.php";
            break;
        case WXT_UrlFeed_Type_New_ChangeSeller:
            url = @"/sale.php";
            break;
        case WXT_UrlFeed_Type_New_Classify:
            url = @"/theme.php";
            break;
        case WXT_UrlFeed_Type_Home_GoodsInfo:
            url = @"/single_goods_info.php";
            break;
        case WXT_UrlFeed_Type_Home_LimitGoodsInfo:
            url = @"/seckill_goods_info.php";
            break;
        case WXT_UrlFeed_Type_NewMall_ImgAndText:
            url = @"";
            break;
        case WXT_UrlFeed_Type_New_CheckAreaVersion:
            url = @"/get_area_version.php";
            break;
        case WXT_UrlFeed_Type_New_LoadAreaData:
            url = @"/area.php";
            break;
        case WXT_UrlFeed_Type_NewMall_NewUserAddress:
            url = @"/user_address.php";
            break;
        case WXT_UrlFeed_Type_NewMall_ShoppingCart:
            url = @"/shopping_cart.php";
            break;
        case WXT_UrlFeed_Type_New_SearchCarriageMoney:
            url = @"/postage.php";
            break;
        case WXT_UrlFeed_Type_New_MakeOrder:
            url = @"/insert_order.php";
            break;
        case WXT_UrlFeed_Type_New_MakeLimitOrder:
            url = @"/seckill_order.php";
            break;
        case WXT_UrlFeed_Type_New_CancelOrder:
            url = @"/cancel_order.php";
            break;
        case WXT_UrlFeed_Type_New_CompleteOrder:
            url = @"/ack_receiving.php";
            break;
        case WXT_UrlFeed_Type_New_LoadMyClientInfo:
            url = @"/divide_single_user.php";
            break;
        case WXT_UrlFeed_Type_New_LoadUserAliAccount:
            url = @"/withdraw_account.php";
            break;
        case WXT_UrlFeed_Type_New_LoadMyClientPerson:
            url = @"/divide_userlist.php";
            break;
        case WXT_UrlFeed_Type_New_LoadMyCutInfo:
            url = @"/divide_home.php";
            break;
        case WXT_UrlFeed_Type_New_JuniorList:
            url = @"/divide_ranking_list.php";
            break;
        case WXT_UrlFeed_Type_New_UserCutSource:
            url = @"/divide_all_source.php";
            break;
        case WXT_UrlFeed_Type_New_ApplyAliMoney:
            url = @"/user_withdraw.php";
            break;
        case WXT_UrlFeed_Type_New_SubmitUserAliAcount:
            url = @"/set_withdraw_account.php";
            break;
        case WXT_UrlFeed_Type_New_LoadAliRecordList:
            url = @"/user_withdraw_list.php";
            break;
        case WXT_UrlFeed_Type_New_SearchGoodsOrShop:
            url = @"/search.php";
            break;
        case WXT_UrlFeed_Type_New_SharkNumber:
            url = @"/award_number.php";
            break;
        case WXT_UrlFeed_Type_New_LuckyGoodsList:
            url = @"/award_goods.php";
            break;
        case WXT_UrlFeed_Type_New_LuckyShark:
            url = @"/lottery_draw.php";
            break;
        case WXT_UrlFeed_Type_New_LuckyGoodsInfo:
            url = @"/single_goods_info.php";
            break;
        case WXT_UrlFeed_Type_New_LuckyMakeOrder:
            url = @"/insert_award_order.php";
            break;
        case WXT_UrlFeed_Type_New_LuckyOrderList:
            url = @"/award_order.php";
            break;
        case WXT_UrlFeed_Type_New_LuckyTimes:
            url = @"/exchange_fare.php";
            break;
        case WXT_UrlFeed_Type_New_PayAttention:
            url = @"/stores.php";
            break;
        case WXT_UrlFeed_Type_New_RechargeCt:
            url = @"/xnb_card.php";
            break;
        case WXT_UrlFeed_Type_VirtualGoods:
            url = @"/list_exchange_goods.php";
            break;
        case WXT_UrlFeed_Type_VirtualOrder:
            url = @"/insert_exchange_order.php";
            break;
        case WXT_UrlFeed_Type_VirtualConfirmOrder:
            url = @"//order_success.php";
            break;
        case WXT_UrlFeed_Type_New_MoreMoneyInfo:
            url = @"/balance.php";
            break;
        case WXT_UrlFeed_Type_New_UserCTRecord:
            url = @"/xnb_log.php";
            break;
        case WXT_UrlFeed_Type_VirtualGoodsInfo:
            url = @"/exchange_goods_detail.php";
            break;
        case WXT_UrlFeed_Type_New_UserMoneyForm:
            url = @"/withdraw_info_count.php";
            break;
        case WXT_UrlFeed_Type_New_UserMoneyInfo:
            url = @"/cash_log.php";
            break;
        case WXT_UrlFeed_Type_VirtualOrderList:
            url = @"/exchange_order_list.php";
            break;
        case WXT_UrlFeed_Type_VirtualCanCelOrder:
            url = @"/exchange_order_cancel.php";
            break;
        case WXT_UrlFeed_Type_New_XNBBalance:
            url = @"/combo.php";
            break;
        case WXT_UrlFeed_Type_New_XNBOrderID:
            url = @"/insert_recharge_order.php";
            break;
        default:
            break;
    }
    if(allUrl){
        return [NSString stringWithFormat:@"%@%@",WXTBaseUrl,allUrl];
    }
    NSString *compURL = nil;
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
