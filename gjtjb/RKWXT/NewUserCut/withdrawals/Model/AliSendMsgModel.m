//
//  AliSendMsgModel.m
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "AliSendMsgModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation AliSendMsgModel

/*
 接口名称:发送短信
 接口地址:https://oldyun.67call.com/wx10api/get_rcode.php
 请求方式:POST
 输入参数:
	pid:平台类型(android,ios),
	ts:时间戳,
	phone:手机号,
	type: 1.注册   2.重置密码  3.微信绑定手机  4.设置提现账号
	sign: 签名
 返回数据格式:json
 成功返回: error :0  data:我信ID
 失败返回:error :1  msg:错误信息
 */

-(void)sendALiMsg:(NSString*)phone{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:phone, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",  [NSNumber numberWithInt:(int)4], @"type", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",  [NSNumber numberWithInt:(int)4], @"type", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Code httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(sendALiMsgFailed:)]){
                [_delegate sendALiMsgFailed:retData.errorDesc];
            }
        }else{
            [userObj setSmsID:[[[retData.data objectForKey:@"data"] objectForKey:@"rand_id"]integerValue]];
            if([_delegate respondsToSelector:@selector(sendALiMsgSucceed)]){
                [_delegate sendALiMsgSucceed];
            }
        }
    }];
}

@end
