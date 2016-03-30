//
//  ConfirmUserAliModel.m
//  RKWXT
//
//  Created by SHB on 15/9/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ConfirmUserAliModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation ConfirmUserAliModel

/*
 接口名称：设置提现账号
 接口地址：https://oldyun.67call.com/wx10api/V1/set_withdraw_account.php
 请求方式：POST
 输入参数：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 sid : 商家ID
 woxin_id : 我信ID
 phone:登录的手机号
 account : 支付宝账号
 username : 支付宝姓名
 type:操作类型  1.添加  2.修改
 rand_id:验证码ID
 rcode:验证码
 sign: 签名
 */

-(void)confirmUserAliAcountWith:(NSString *)userAliAcount with:(NSString *)userName with:(UserAli_Submit)aliType with:(NSInteger)rcode with:(NSString *)userPhone{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userAliAcount, @"account", userName, @"username", [NSNumber numberWithInt:(int)aliType], @"type", [NSNumber numberWithInt:(int)rcode], @"rcode", [NSNumber numberWithInt:(int)userObj.smsID], @"rand_id", userPhone, @"phone", nil];
    
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"sid"]= userObj.sellerID;
    baseDic[@"account"]= userAliAcount;
    baseDic[@"username"]= userName;
    baseDic[@"type"]= [NSNumber numberWithInt:(int)aliType];
    baseDic[@"rand_id"]= [NSNumber numberWithInt:(int)userObj.smsID];
    baseDic[@"rcode"]= [NSNumber numberWithInt:(int)rcode];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"sid"]= userObj.sellerID;
    dic[@"account"]= userAliAcount;
    dic[@"username"]= userName;
    dic[@"type"]= [NSNumber numberWithInt:(int)aliType];
    dic[@"rand_id"]= [NSNumber numberWithInt:(int)userObj.smsID];
    dic[@"rcode"]= [NSNumber numberWithInt:(int)rcode];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_SubmitUserAliAcount httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(confirmUserAliAcountFailed:)]){
                [_delegate confirmUserAliAcountFailed:retData.errorDesc];
            }
        }else{
            if([_delegate respondsToSelector:@selector(confirmUserAliAcountSucceed)]){
                [_delegate confirmUserAliAcountSucceed];
            }
        }
    }];
}

@end
