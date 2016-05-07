//
//  VirtualGoodsInfoModel.m
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualGoodsInfoModel.h"
#import "VirtualGoodsInfoEntity.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface VirtualGoodsInfoModel ()
{
    NSMutableArray *_goodsInfoArr;
    NSMutableArray *_attrArr;
    NSMutableArray *_stockArr;
    NSMutableArray *_sellerArr;
    BOOL _isAppear;
}
@end

@implementation VirtualGoodsInfoModel
@synthesize goodsInfoArr = _goodsInfoArr;
@synthesize sellerArr = _sellerArr;
@synthesize attrArr = _attrArr;
@synthesize stockArr = _stockArr;

-(id)init{
    self = [super init];
    if(self){
        _isAppear = NO;
        _goodsInfoArr = [[NSMutableArray alloc] init];
        _stockArr = [[NSMutableArray alloc] init];
        _attrArr = [[NSMutableArray alloc] init];
        _sellerArr = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)parseGoodsInfoData:(NSDictionary*)dic type:(NSInteger)type{
    if(!dic) return;
    
    [_goodsInfoArr removeAllObjects];
    [_stockArr removeAllObjects];
    [_attrArr removeAllObjects];
    [_sellerArr removeAllObjects];
    
    //商家信息
    VirtualGoodsInfoEntity *sellerEntity = [VirtualGoodsInfoEntity initSellerInfoEntity:[dic objectForKey:@"seller"]];
    [_sellerArr addObject:sellerEntity];
    
    //基础信息
    if([[dic objectForKey:@"attr"] isKindOfClass:[NSArray class]]){
        for(NSDictionary *attrDic in [dic objectForKey:@"attr"]){
            VirtualGoodsInfoEntity *attrEntity = [VirtualGoodsInfoEntity initBaseAttrDataEntity:attrDic];
            [_attrArr addObject:attrEntity];
        }
    }
    
        //库存
        for(NSDictionary *stockDic in [dic objectForKey:@"stock"]){
            VirtualGoodsInfoEntity *stockEntity = [VirtualGoodsInfoEntity initStockDataEntity:stockDic];
            [_stockArr addObject:stockEntity];
        }
        
        //商品详情
        VirtualGoodsInfoEntity *goodsInfoEntity = [VirtualGoodsInfoEntity initGoodsInfoEntity:[dic objectForKey:@"goods"]];
        goodsInfoEntity.homeImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,goodsInfoEntity.homeImg];
        goodsInfoEntity.goodsImgArr = [self goodsInfoTopImgArrWithImgString:goodsInfoEntity.goodsImg];
        goodsInfoEntity.goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,goodsInfoEntity.goodsImg];
        [_goodsInfoArr addObject:goodsInfoEntity];
    
  
  
}


-(NSArray*)goodsInfoTopImgArrWithImgString:(NSString*)imgStr{
    if(!imgStr){
        return nil;
    }
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    NSArray *array = [imgStr componentsSeparatedByString:@","];
    for (NSString *str in array) {
        NSString *str1 = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,str];
        [imgArr addObject:str1];
    }
    return imgArr;
}

/*
 接口名称：兑换商城的单个商品详情
 接口地址：https://oldyun.67call.com/wx10api/V1/exchange_goods_detail.php
 请求方式:POST
 pid:平台类型(android,ios),
 ts:时间戳,
 woxin_id:我信ID
 phone: 登录的手机号
 goods_id: 商品ID
 sign: 签名
 返回数据格式:json
 成功返回: error :0  data:数据
 失败返回:error :1  msg:错误信息
 */

-(void)virtualLoadGoodsInfoData:(NSInteger)goodsID type:(VirtualModelRequestType)type{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:goodsID], @"goods_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:goodsID], @"goods_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block VirtualGoodsInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_VirtualGoodsInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(virtualLoadGoodsInfoDataFailed:)]){
                [_delegate virtualLoadGoodsInfoDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseGoodsInfoData:[retData.data objectForKey:@"data"]   type:VirtualModelRequestType_Default];
            if(_delegate && [_delegate respondsToSelector:@selector(virtualLoadGoodsInfoDataSucceed)]){
                [_delegate virtualLoadGoodsInfoDataSucceed];
            }
        }
    }];
}

@end
