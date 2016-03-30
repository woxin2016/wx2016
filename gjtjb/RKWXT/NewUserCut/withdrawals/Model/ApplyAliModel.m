//
//  ApplyAliModel.m
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ApplyAliModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation ApplyAliModel
/*
 接口名称：用户申请提现
 接口地址：https://oldyun.67call.com/wx10api/V1/user_withdraw.php
 请求方式：POST
 输入参数：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 sid : 商家ID
 woxin_id : 我信ID
 phone:登录的手机号
 amount : 提现金额
 sign: 签名
 */

-(void)applyAliMoney:(CGFloat)money{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithFloat:(float)money], @"amount", nil];
    
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"sid"]= userObj.sellerID;
    baseDic[@"amount"]= [NSNumber numberWithFloat:(float)money];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"sid"]= userObj.sellerID;
    dic[@"amount"]= [NSNumber numberWithFloat:(float)money];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_ApplyAliMoney httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(applyAliMoneyFailed:)]){
                [_delegate applyAliMoneyFailed:retData.errorDesc];
            }
        }else{
            if([_delegate respondsToSelector:@selector(applyAliMoneySucceed)]){
                [_delegate applyAliMoneySucceed];
            }
        }
    }];
}

@end
