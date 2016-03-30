//
//  WXJuniorListModel.m
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXJuniorListModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "JuniorListEntity.h"

@interface WXJuniorListModel(){
    NSMutableArray *_juniorArr;
}
@end

@implementation WXJuniorListModel
@synthesize juniorArr = _juniorArr;

-(id)init{
    self = [super init];
    if(self){
        _juniorArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseJuniorListDataWith:(NSArray*)arr{
    if(!arr){
        return;
    }
    [_juniorArr removeAllObjects];
    NSInteger count = 0;
    for(NSDictionary *dic in arr){
        count++;
        
        JuniorListEntity *entity = [JuniorListEntity initJuniorListEntity:dic];
        if(![entity.imgUrl isEqualToString:@""] && entity.imgUrl){
            entity.imgUrl = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.imgUrl];
        }
        entity.rankingNum = count;
        [_juniorArr addObject:entity];
    }
}

/*
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 sid : 商家ID
 woxin_id : 我信ID
 phone:登录的手机号
 sign: 签名
 */

-(void)loadWXJuniorListData{
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
    
    __block WXJuniorListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_JuniorList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadWXJuniorListDataFailed:)]){
                [_delegate loadWXJuniorListDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseJuniorListDataWith:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadWXJuniorListDataSucceed)]){
                [_delegate loadWXJuniorListDataSucceed];
            }
        }
    }];
}

@end
