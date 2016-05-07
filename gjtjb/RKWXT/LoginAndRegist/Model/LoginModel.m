//
//  LoginModel.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LoginModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation LoginModel

-(void)loginWithUser:(NSString *)userStr pwd:(NSString *)pwdStr completion:(void (^)(NSInteger, NSString *))completion{
    NSString *pwdString = [UtilTool md5:pwdStr];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userStr, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", pwdString, @"pwd", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userStr, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", pwdString, @"pwd", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Login httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        NSDictionary *dic = retData.data;
        if (retData.code == 0){
            WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
            [userDefault setUser:userStr];
            [userDefault setPwd:pwdStr];
            [userDefault setWxtID:[[dic objectForKey:@"data"] objectForKey:@"woxin_id"]];
            [userDefault setSellerID:[[dic objectForKey:@"data"] objectForKey:@"seller_id"]]; //用户所属商家id
            [userDefault setSellerName:[[dic objectForKey:@"data"] objectForKey:@"seller_name"]]; //用户所属商家
            [userDefault setShopID:[[dic objectForKey:@"data"] objectForKey:@"shop_id"]]; //用户所在店铺id
            [userDefault setShopName:[[dic objectForKey:@"data"] objectForKey:@"shop_name"]]; //用户所在店铺
            [userDefault setNickname:[[dic objectForKey:@"data"] objectForKey:@"nickname"]]; //用户昵称
            [userDefault setUserIdentity:[[dic objectForKey:@"data"] objectForKey:@"is_sale"]]; //是否为特殊用户
        }
        completion(retData.code,retData.errorDesc);
    }];

}

/*
 接口名称:首次登录推送
 接口地址:https://oldyun.67call.com/wx10api/V1/login_push.php
 请求方式:POST
 输入参数:
 pid:平台类型(android,ios),
 ts:时间戳,
 phone:手机号码,
 pwd:密码,
 sign: 签名,
 返回数据格式:json
 成功返回: error :0  msg:没有推送
 失败返回:error :1  msg:已经推送
 */
- (void)sendUserMessage{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"pwd"]= [UtilTool  md5:userObj.pwd];
    baseDic[@"phone"]= userObj.user;
    baseDic[@"sid"]= [NSNumber numberWithInt:(int)kMerchantID];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"pwd"]= [UtilTool  md5:userObj.pwd];
    dic[@"phone"]= userObj.user;
    dic[@"sid"]= [NSNumber numberWithInt:(int)kMerchantID];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
  
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_LosinMessage httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code == 0){
            
        }else{
            
        }
    }];
}

@end
