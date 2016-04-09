//
//  ViteualGoodsModel.m
//  RKWXT
//
//  Created by app on 16/4/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ViteualGoodsModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "ViteualGoodsEntity.h"

@interface ViteualGoodsModel ()
{
    NSMutableArray *_goodsArray;
    ModelType  notType;
}
@end

@implementation ViteualGoodsModel
@synthesize goodsArray = _goodsArray;
-(instancetype)init{
    if (self = [super init]) {
        _goodsArray = [NSMutableArray array];
        notType = ModelType_Store;
    }
    return self;
}

/*
 接口名称：获取所有的云票兑换的商品
 接口地址：https://oldyun.67call.com/wx10api/V1/list_exchange_goods.php
 请求方式：POST
 输入参数：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 sid : 商家ID
 woxin_id : 我信ID
 phone:登录的手机号
 start_item:起始条目
 length:长度
 type: 1.兑换商城 2.品牌兑换
 sign: 签名
 返回数据格式：json
 成功返回: error ：0  data:数据
 失败返回：error ：1  msg:错误信息
 */
- (void)viteualGoodsModelRequeatNetWork:(ModelType)type start:(NSInteger)start length:(NSInteger)length{
   
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"sid"]= [NSNumber numberWithInt:(int)kMerchantID];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"start_item"]= [NSNumber numberWithInteger:start];
    baseDic[@"length"]= [NSNumber numberWithInteger:length];
    baseDic[@"type"]= [NSNumber numberWithInteger:type];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"sid"]= [NSNumber numberWithInt:(int)kMerchantID];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    dic[@"start_item"]= [NSNumber numberWithInteger:start];
    dic[@"length"]= [NSNumber numberWithInteger:length];
    dic[@"type"]= [NSNumber numberWithInteger:type];
    
    __block ViteualGoodsModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_VirtualGoods httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(viteualGoodsModelFailed:)]) {
                [_delegate viteualGoodsModelFailed:retData.errorDesc];
            }
        }else{
            [blockSelf  handleReturnData:retData.data[@"data"]  type:type];
            if (_delegate && [_delegate respondsToSelector:@selector(viteualGoodsModelSucceed)]) {
                [_delegate viteualGoodsModelSucceed];
            }
        }
    }];
}

- (void)handleReturnData:(NSArray*)data type:(ModelType)type{
    
    if ([data count] <= 0) return;
    
    if (notType != type) {
        notType = type;
       [_goodsArray removeAllObjects];
    }
    
    for (NSDictionary *dic in data) {
        ViteualGoodsEntity *entity = [ViteualGoodsEntity  viteualGoodsEntityWithDic:dic];
        [_goodsArray addObject:entity];
    }
    
}



@end
