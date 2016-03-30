//
//  MyClientInfoModel.m
//  RKWXT
//
//  Created by SHB on 15/9/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MyClientInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface MyClientInfoModel(){
    NSMutableArray *_myClientInfoArr;
}
@end

@implementation MyClientInfoModel
@synthesize myClientInfoArr = _myClientInfoArr;

-(id)init{
    self = [super init];
    if(self){
        _myClientInfoArr = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 sid : 商家ID
 woxin_id : 我信ID
 subuser_woxin_id : 下线的用户ID
 phone:登录的手机号
 sign: 签名
 */

-(void)loadMyClientInfoWithWxID:(NSString *)wxID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"subuser_woxin_id"]= wxID;
    baseDic[@"sid"]= userObj.sellerID;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"sid"]= userObj.sellerID;
    dic[@"subuser_woxin_id"]= wxID;
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    __block MyClientInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadMyClientInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadMyClientInfoFailed:)]){
                [_delegate loadMyClientInfoFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseMyCutInfoDataWithDic:[retData.data objectForKey:@"data"]];
            if([_delegate respondsToSelector:@selector(loadMyClientInfoSucceed)]){
                [_delegate loadMyClientInfoSucceed];
            }
        }
    }];
}

-(void)parseMyCutInfoDataWithDic:(NSArray*)arr{
    if(!arr){
        return;
    }
    [_myClientInfoArr removeAllObjects];
    for(NSDictionary *dic in arr){
        NSString *money = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"ivide_money"] floatValue]];
        [_myClientInfoArr addObject:money];
    }
}

@end
