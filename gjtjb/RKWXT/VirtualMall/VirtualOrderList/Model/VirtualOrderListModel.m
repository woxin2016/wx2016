//
//  VirtualOrderListModel.m
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualOrderListModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "virtualOrderListEntity.h"

@interface VirtualOrderListModel ()
{
    NSMutableArray *dataArray;
    NSInteger _number;
}
@end

@implementation VirtualOrderListModel

- (instancetype)init{
    if (self = [super init]) {
        dataArray = [NSMutableArray array];
    }
    return self;
}

/*
 接口名称：兑换订单列表
 接口地址：https://oldyun.67call.com/wx10api/V1/exchange_order_list.php
 请求方式：POST
 输入参数：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 sid : 商家ID
 woxin_id : 我信ID
 phone:登录的手机号
 start_item:起始条目
 length:长度
 sign: 签名
 返回数据格式：json
 成功返回: error ：0  data:数据
 失败返回：error ：1  msg:错误信息
 */

- (void)loadVirtualOrderListWithStart:(NSInteger)start lenght:(NSInteger)lenght{
    _number = start;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"sid"]= [NSNumber numberWithInt:(int)kMerchantID];
    baseDic[@"start_item"] = [NSNumber numberWithInteger:start];
    baseDic[@"length"] = [NSNumber numberWithInteger:lenght];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"sid"]= [NSNumber numberWithInt:(int)kMerchantID];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    dic[@"start_item"] = [NSNumber numberWithInteger:start];
    dic[@"length"] = [NSNumber numberWithInteger:lenght];
    
    __block VirtualOrderListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_VirtualOrderList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(virtualGoodsOrderListFailed:)]) {
                [_delegate virtualGoodsOrderListFailed:retData.errorDesc];
            }
            
        }else{
            [blockSelf analyticalProcessingOrderData:retData.data[@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(VirtualOrderListLoadSucceed)]) {
                [_delegate VirtualOrderListLoadSucceed];
            }
            
        }
    }];

}

- (void)analyticalProcessingOrderData:(NSDictionary*)dic{
    if (_number == 0) {
        [dataArray removeAllObjects];
    }
    
    NSArray *orderArray = dic[@"order"];
    for (NSDictionary *dict in orderArray) {
        virtualOrderListEntity *entity = [virtualOrderListEntity virtualOrderListEntityWidthDic:dict];
        entity.orderPrefix = dic[@"order_prefix"];
        [dataArray addObject:entity];
    }
    self.listArray = dataArray;
}


/*
 接口名称：取消兑换的订单
 接口地址：https://oldyun.67call.com/wx10api/V1/exchange_order_cancel.php
 请求方式：POST
 输入参数：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 sid : 商家ID
 woxin_id : 我信ID
 phone:登录的手机号
 order_id:订单ID
 sign: 签名
 返回数据格式：json
 成功返回: error ：0  data:数据
 失败返回：error ：1  msg:错误信息
 */
- (void)cancelOrderIDWith:(NSInteger)orderID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"sid"]= [NSNumber numberWithInt:(int)kMerchantID];
    baseDic[@"order_id"] = [NSNumber numberWithInteger:orderID];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"sid"]= [NSNumber numberWithInt:(int)kMerchantID];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    dic[@"order_id"] = [NSNumber numberWithInteger:orderID];
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_VirtualCanCelOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [[NSNotificationCenter defaultCenter]postNotificationName:V_Notification_Name_CancelVirtualOrderFailure object:nil];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:V_Notification_Name_CancelVirtualOrderSuccend object:nil];
        }
    }];
    
}

/*
 接口名称:确认完成收货
 接口地址:https://oldyun.67call.com/wx10api/V1/order_success.php
 请求方式:POST
 输入参数:
 pid:平台类型(android,ios),
 ts:时间戳,
 woxin_id : 我信ID
 phone:手机号码,
 pwd:密码,
 order_id:订单ID,
 sign: 签名,
 返回数据格式:json
 成功返回: error :0  data:数据
 失败返回:error :1  msg:错误信息
 */
- (void)confirmOrderBtnWithOrderID:(NSInteger)orderID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"pwd"]= [UtilTool md5:userObj.pwd];
    baseDic[@"order_id"] = [NSNumber numberWithInteger:orderID];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"pwd"]= [UtilTool md5:userObj.pwd];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    dic[@"order_id"] = [NSNumber numberWithInteger:orderID];
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_VirtualConfirmOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
//            [[NSNotificationCenter defaultCenter]postNotificationName:V_Notification_Name_CancelVirtualConfirmOrderFailure object:nil];
            if (_delegate && [_delegate respondsToSelector:@selector(VirtualConfirmOrderFailure:)]) {
                [_delegate VirtualConfirmOrderFailure:retData.errorDesc];
            }
        }else{
//            [[NSNotificationCenter defaultCenter]postNotificationName:V_Notification_Name_CancelVirtualConfirmOrderSuccend object:nil];
            if (_delegate && [_delegate respondsToSelector:@selector(VirtualConfirmOrderSuccend)]) {
                [_delegate VirtualConfirmOrderSuccend];
            }
        }
    }];

}

@end
