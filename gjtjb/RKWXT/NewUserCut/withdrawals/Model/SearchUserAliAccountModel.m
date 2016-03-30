//
//  SearchUserAliAccountModel.m
//  RKWXT
//
//  Created by SHB on 15/9/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "SearchUserAliAccountModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "UserAliEntity.h"

@interface SearchUserAliAccountModel(){
    NSMutableArray *_userAliAcountArr;
}
@end

@implementation SearchUserAliAccountModel
@synthesize userAliAcountArr = _userAliAcountArr;

-(id)init{
    self = [super init];
    if(self){
        _userAliAcountArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseUserAliAcountData:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    if ([dic[@"data"] count] == 0) {
        return;
    }
    UserAliEntity *entity = [[UserAliEntity alloc] init];
    if([[dic objectForKey:@"data"] isKindOfClass:[NSString class]]){
        entity.userali_type = UserAliCount_Type_None;
        [_userAliAcountArr addObject:entity];
    }else{
        entity = [UserAliEntity initUserAliAcountWithDic:[dic objectForKey:@"data"]];
        [_userAliAcountArr addObject:entity];
    }
}

/*
 接口名称：获取提现账号
 接口地址：https://oldyun.67call.com/wx10api/V1/withdraw_account.php
 请求方式：POST
 输入参数：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 sid : 商家ID
 woxin_id : 我信ID
 phone:登录的手机号
 sign: 签名
 */

-(void)searchUserAliPayAccount{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"sid"]= userObj.sellerID;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"sid"]= userObj.sellerID;
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    __block SearchUserAliAccountModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadUserAliAccount httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(searchUserAliPayAccountFailed:)]){
                [_delegate searchUserAliPayAccountFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseUserAliAcountData:retData.data];
            if([_delegate respondsToSelector:@selector(searchUserAliPayAccountSucceed)]){
                [_delegate searchUserAliPayAccountSucceed];
            }
        }
    }];
}

@end
