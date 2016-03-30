//
//  MyClientPersonModel.m
//  RKWXT
//
//  Created by SHB on 15/9/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MyClientPersonModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "MyClientEntity.h"

@interface MyClientPersonModel(){
    NSMutableArray *_clientList;
}
@end

@implementation MyClientPersonModel
@synthesize clientList = _clientList;

-(id)init{
    self = [super init];
    if(self){
        _clientList = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 woxin_id : 我信ID
 phone:登录的手机号
 level : 级别 1,2,3
 sid : 商家ID
 sign: 签名
 */
-(void)loadMyClientPersonList:(MyClient_Grade)client_grade{
    if(client_grade > MyClient_Grade_Invalid){
        return;
    }
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"sid"]= userObj.sellerID;
    baseDic[@"level"]= [NSNumber numberWithInt:(int)client_grade];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"sid"]= userObj.sellerID;
    dic[@"level"]= [NSNumber numberWithInt:(int)client_grade];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    __block MyClientPersonModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadMyClientPerson httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadMyClientPersonListFailed:)]){
                [_delegate loadMyClientPersonListFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseMyClientPersonListWith:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadMyClientPersonListSucceed)]){
                [_delegate loadMyClientPersonListSucceed];
            }
        }
    }];
}

-(void)parseMyClientPersonListWith:(id)arr{
    if(!arr){
        return;
    }
    if([arr isKindOfClass:[NSString class]]){
        return;
    }
    [_clientList removeAllObjects];
    for(NSDictionary *dic in arr){
        MyClientEntity *entity = [MyClientEntity initMyClientPersonWithDic:dic];
        entity.userIconImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.userIconImg];
        [_clientList addObject:entity];
    }
}

@end
