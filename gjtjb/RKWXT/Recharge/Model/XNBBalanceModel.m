//
//  XNBBalanceModel.m
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "XNBBalanceModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "XNBBalanceEntity.h"
#import "XNBOrderEntity.h"



@implementation XNBBalanceModel
- (NSMutableArray*)cartArray{
    if (!_cartArray) {
        _cartArray = [NSMutableArray array];
    }
    return _cartArray;
}

// 获取套餐
/*
 接口名称:获取充值套餐
 接口地址:https://oldyun.67call.com/wx10api/V1/combo.php
 请求方式:POST
 输入参数:
 pid:平台类型(android,ios),
 ts:时间戳,
 woxin_id:我信ID
 phone:手机号
 sign: 签名
 返回数据格式:json
 成功返回: error :0  data:数据
 失败返回:error :1  msg:错误信息
 */
- (void)requestLoadCartInfo{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block XNBBalanceModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_XNBBalance httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(loadXNBUserBalanceFailed:)]){
                [_delegate loadXNBUserBalanceFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseXNBClassifyData:[retData.data objectForKey:@"data"]];
            
            if (_delegate && [_delegate respondsToSelector:@selector(loadXNBUserBalanceSucceed)]){
                [_delegate loadXNBUserBalanceSucceed];
            }
        }
    }];
}

- (void)parseXNBClassifyData:(NSDictionary*)data{
    [self.cartArray removeAllObjects];
    if (!data)return;
    NSArray *array = data[@"combo"];
    if (array.count == 0) return;
    
    for (NSDictionary *dic in array) {
        XNBBalanceEntity *entity = [XNBBalanceEntity xnbBalanceEntityWithDict:dic];
        entity.xnbBalnce = [data[@"xnb_1"] intValue];
        [self.cartArray addObject:entity];
    }
}

/*
 接口名称:写入话费充值订单
 接口地址:https://oldyun.67call.com/wx10api/V1/insert_recharge_order.php
 请求方式:POST
 输入参数:
 pid:平台类型(android,ios),
 ts:时间戳,
 woxin_id:我信ID
 recharge_phone:充值的手机号
 combo_key:套餐类型
 sign: 签名
 返回数据格式:json
 成功返回: error :0  data:数据
 失败返回:error :1  msg:错误信息
 */

- (void)balanceSubmitOrdersWithKey:(NSInteger)key phone:(NSString*)phone{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"recharge_phone"]= phone;
    baseDic[@"combo_key"]= [NSNumber numberWithInteger:key];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"recharge_phone"]= phone;
    dic[@"combo_key"]= [NSNumber numberWithInteger:key];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    __block XNBBalanceModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_XNBOrderID httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(balanceSubmitOrderFailed:)]){
                [_delegate balanceSubmitOrderFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseOrderData:[retData.data objectForKey:@"data"]];
            
            if (_delegate && [_delegate respondsToSelector:@selector(balanceSubmitOrderSucceed)]){
                [_delegate balanceSubmitOrderSucceed];
            }
        }
    }];

}

- (void)parseOrderData:(NSDictionary*)data{
    if (!data)return;
    self.order = [XNBOrderEntity xnbOrderEntityWithDic:data];
}

@end
