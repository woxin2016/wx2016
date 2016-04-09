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
    
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"shop_id"]= userObj.shopID;
    baseDic[@"sid"]= userObj.sellerID;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"shop_id"]= userObj.shopID;
    dic[@"sid"]= userObj.sellerID;
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    __block HomeLimitGoodsModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadLimitGoods httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [_dataList removeAllObjects];
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageLimitGoodsFailed:)]){
                [_delegate homePageLimitGoodsFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf fillDataWithJsonData:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageLimitGoodsSucceed)]){
                [_delegate homePageLimitGoodsSucceed];
            }
        }
    }];
}

- (void)fillDataWithJsonData:(NSDictionary *)jsonDicData{
    if (!jsonDicData) return;
    [_dataList removeAllObjects];
    
    HomeLimitGoodsEntity *limit = [HomeLimitGoodsEntity homeLimitGoodsWithDic:jsonDicData[@"data"]];
    [_dataList addObject:limit];
    
    [self setIsBeglimit:[jsonDicData[@"data"] objectForKey:@"begin_time"]];
    
}

- (void)setIsBeglimit:(NSString *)str{
    NSDate *startDate =  [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    NSTimeInterval start  = [startDate timeIntervalSince1970];
    NSTimeInterval nowDate = [[NSDate date] timeIntervalSince1970];
    
    if (nowDate < start) {  // 现在时间  大于 开始时间
        if (_delegate && [_delegate respondsToSelector:@selector(limitBuyNoStartBuyGoods)]) {
            [_delegate limitBuyNoStartBuyGoods];
        }
    }
}

- (void)loadCacheDataSucceed{
    if (_delegate && [_delegate respondsToSelector:@selector(homePageLimitGoodsSucceed)]){
        [_delegate homePageLimitGoodsSucceed];
    }
}

@end
