//
//  WithdrawadsRecordListModel.m
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WithdrawadsRecordListModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "WithdrawalsRecordEntity.h"

@interface WithdrawadsRecordListModel(){
    NSMutableArray *_recordListArr;
}
@end

@implementation WithdrawadsRecordListModel
@synthesize recordListArr = _recordListArr;

-(id)init{
    self = [super init];
    if(self){
        _recordListArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseLuckyGoodsWith:(NSArray*)arr{
    if(!arr){
        return;
    }
    if(_type == AliMoney_RecordList_Normal || _type == AliMoney_RecordList_Refresh){
        [_recordListArr removeAllObjects];
    }
    
    for(NSDictionary *dic in arr){
        WithdrawalsRecordEntity *entity = [WithdrawalsRecordEntity initAliRecordListWithDic:dic];
        [_recordListArr addObject:entity];
    }
}
/*
 接口地址：https://oldyun.67call.com/wx10api/user_withdraw_list.php
 请求方式：POST
 输入参数：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 sid : 商家ID
 woxin_id : 我信ID
 phone:登录的手机号
 start_item: 查询起始条目
 length: 查询的条目数量
 sign: 签名
 */
-(void)loadUserWithdrawadlsRecordList:(NSInteger)startItem With:(NSInteger)length{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"start_item"]= [NSNumber numberWithFloat:(int)startItem];
    baseDic[@"length"]= [NSNumber numberWithInt:(int)length];
    baseDic[@"sid"]= userObj.sellerID;
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"sid"]= userObj.sellerID;
    dic[@"start_item"]= [NSNumber numberWithFloat:(int)startItem];
    dic[@"length"]= [NSNumber numberWithInt:(int)length];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    __block WithdrawadsRecordListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadAliRecordList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadUserWithdrawadlsRecordListFailed:)]){
                [_delegate loadUserWithdrawadlsRecordListFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseLuckyGoodsWith:[retData.data objectForKey:@"data"]];
            if([_delegate respondsToSelector:@selector(loadUserWithdrawadlsRecordListSucceed)]){
                [_delegate loadUserWithdrawadlsRecordListSucceed];
            }
        }
    }];
}

@end
