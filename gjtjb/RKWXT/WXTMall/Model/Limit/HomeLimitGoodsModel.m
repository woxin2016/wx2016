//
//  HomeLimitGoodsModel.m
//  RKWXT
//
//  Created by app on 16/3/10.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "HomeLimitGoodsModel.h"
#import "HomePageSurpEntity.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "HomeLimitGoodsEntity.h"
#import "LImitGoodsEntity.h"



@interface HomeLimitGoodsModel(){
    NSMutableArray *_dataList;
}
@end

@implementation HomeLimitGoodsModel
@synthesize data = _dataList;

-(id)init{
    if(self = [super init]){
        _dataList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)toInit{
    [super toInit];
    [_dataList removeAllObjects];
}

/*
 接口名称：获取秒杀活动列表
 接口地址：https://oldyun.67call.com/wx10api/V1/seckills.php
 请求方式：POST
 输入参数：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 shop_id:店铺ID
 sign: 签名
 返回数据格式：json
 */
- (void)loadDataFromWeb{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
//    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.shopID, @"shop_id", nil];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.shopID, @"shop_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"shop_id"]= userObj.shopID;
    baseDic[@"sid"]= [NSNumber numberWithInt:(int)kMerchantID];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"shop_id"]= userObj.shopID;
    dic[@"sid"]= [NSNumber numberWithInt:(int)kMerchantID];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    __block HomeLimitGoodsModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadLimitGoods httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageSurpLoadedFailed:)]){
                [_delegate homePageSurpLoadedFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf fillDataWithJsonData:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageSurpLoadedSucceed)]){
                [_delegate homePageSurpLoadedSucceed];
            }
        }
    }];
}

- (void)fillDataWithJsonData:(NSDictionary *)jsonDicData{
    if (!jsonDicData) return;
    [_dataList removeAllObjects];
    
    HomeLimitGoodsEntity *limit = [HomeLimitGoodsEntity homeLimitGoodsWithDic:jsonDicData[@"data"]];
    [_dataList addObject:limit];
}



@end
