//
//  GoodsInfoModel.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "GoodsInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "GoodsInfoEntity.h"

@interface GoodsInfoModel(){
    NSMutableArray *_goodsInfoArr;
    NSMutableArray *_evaluteArr;
    NSMutableArray *_attrArr;
    NSMutableArray *_stockArr;
    NSMutableArray *_otherShopArr;
    NSMutableArray *_sellerArr;
}
@end

@implementation GoodsInfoModel
@synthesize goodsInfoArr = _goodsInfoArr;
@synthesize evaluteArr = _evaluteArr;
@synthesize attrArr = _attrArr;
@synthesize stockArr = _stockArr;
@synthesize otherShopArr = _otherShopArr;
@synthesize sellerArr = _sellerArr;

-(id)init{
    self = [super init];
    if(self){
        _goodsInfoArr = [[NSMutableArray alloc] init];
        _stockArr = [[NSMutableArray alloc] init];
        _evaluteArr = [[NSMutableArray alloc] init];
        _attrArr = [[NSMutableArray alloc] init];
        _otherShopArr = [[NSMutableArray alloc] init];
        _sellerArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseGoodsInfoData:(NSDictionary*)dic type:(NSInteger)type{
    if(!dic){
        return;
    }
    [_goodsInfoArr removeAllObjects];
    [_stockArr removeAllObjects];
    [_attrArr removeAllObjects];
    [_evaluteArr removeAllObjects];
    [_otherShopArr removeAllObjects];
    [_sellerArr removeAllObjects];
    
   
    
    //商家信息
    GoodsInfoEntity *sellerEntity = [GoodsInfoEntity initSellerInfoEntity:[dic objectForKey:@"seller"]];
    [_sellerArr addObject:sellerEntity];
    
    //基础信息
    if([[dic objectForKey:@"attr"] isKindOfClass:[NSArray class]]){
        for(NSDictionary *attrDic in [dic objectForKey:@"attr"]){
            GoodsInfoEntity *attrEntity = [GoodsInfoEntity initBaseAttrDataEntity:attrDic];
            [_attrArr addObject:attrEntity];
        }
    }
    

    
    //推荐店铺
    GoodsInfoEntity *shopEntity = [GoodsInfoEntity initOtherShopEntity:[dic objectForKey:@"shop"]];
    [_otherShopArr addObject:shopEntity];
    
    if (type == GoodsInfoModel_Request_Type_Normal) {
        
        //库存
        for(NSDictionary *stockDic in [dic objectForKey:@"stock"]){
            GoodsInfoEntity *stockEntity = [GoodsInfoEntity initStockDataEntity:stockDic];
            [_stockArr addObject:stockEntity];
        }
        
        //商品详情
        GoodsInfoEntity *goodsInfoEntity = [GoodsInfoEntity initGoodsInfoEntity:[dic objectForKey:@"goods"]];
        goodsInfoEntity.homeImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,goodsInfoEntity.homeImg];
        goodsInfoEntity.goodsImgArr = [self goodsInfoTopImgArrWithImgString:goodsInfoEntity.goodsImg];
        goodsInfoEntity.goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,goodsInfoEntity.goodsImg];
        [_goodsInfoArr addObject:goodsInfoEntity];
        
    }else if (type == GoodsInfoModel_Request_Type_LimitGoods){
        
        //秒杀库存
        for(NSDictionary *stockDic in [dic objectForKey:@"stock"]){
            GoodsInfoEntity *stockEntity = [GoodsInfoEntity initLimitStockDataEntity:stockDic];
            [_stockArr addObject:stockEntity];
        }
        
        //商品详情
        GoodsInfoEntity *goodsInfoEntity = [GoodsInfoEntity initLimitGoodsInfoEntity:[dic objectForKey:@"goods"]];
        goodsInfoEntity.homeImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,goodsInfoEntity.homeImg];
        goodsInfoEntity.goodsImgArr = [self goodsInfoTopImgArrWithImgString:goodsInfoEntity.goodsImg];
        goodsInfoEntity.goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,goodsInfoEntity.goodsImg];
        [_goodsInfoArr addObject:goodsInfoEntity];
        
    }
   
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

-(void)loadGoodsInfoData:(NSInteger)goodsID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:goodsID], @"goods_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:goodsID], @"goods_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block GoodsInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_GoodsInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadGoodsInfoDataFailed:)]){
                [_delegate loadGoodsInfoDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseGoodsInfoData:[retData.data objectForKey:@"data"]   type:GoodsInfoModel_Request_Type_Normal];
            if(_delegate && [_delegate respondsToSelector:@selector(loadGoodsInfoDataSucceed)]){
                [_delegate loadGoodsInfoDataSucceed];
            }
        }
    }];
}

/*
 接口名称：获取秒杀商品详情
 接口地址：https://oldyun.67call.com/wx10api/V1/seckill_goods_info.php
 请求方式：POST
 输入参数：
 pid:平台类型(android,ios),
 ts:时间戳,
 woxin_id:我信ID
 phone: 登录的手机号
 goods_id: 商品ID
 seckill_id 秒杀活动ID
 sign: 签名
 */
-(void)loadGoodsInfoData:(NSInteger)goodsID  seckillID:(NSInteger)seckillID type:(NSInteger)type{
    if (type == GoodsInfoModel_Request_Type_LimitGoods) {
       
        WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
        NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
        baseDic[@"pid"]= @"ios";
        baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
        baseDic[@"woxin_id"]= userObj.wxtID;
        baseDic[@"phone"]= userObj.user;
        baseDic[@"seckill_id"]= [NSNumber numberWithInteger:seckillID];
        baseDic[@"goods_id"]= [NSNumber numberWithInteger:goodsID];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"pid"]= @"ios";
        dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
        dic[@"woxin_id"]= userObj.wxtID;
        dic[@"phone"]= userObj.user;
        dic[@"seckill_id"]= [NSNumber numberWithInteger:seckillID];
        dic[@"goods_id"]= [NSNumber numberWithInteger:goodsID];
        dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];

        __block GoodsInfoModel *blockSelf = self;
        [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_LimitGoodsInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
            if(retData.code != 0){
                if(_delegate && [_delegate respondsToSelector:@selector(loadGoodsInfoDataFailed:)]){
                    [_delegate loadGoodsInfoDataFailed:retData.errorDesc];
                }
            }else{
                [blockSelf parseGoodsInfoData:[retData.data objectForKey:@"data"] type:GoodsInfoModel_Request_Type_LimitGoods];
                if(_delegate && [_delegate respondsToSelector:@selector(loadGoodsInfoDataSucceed)]){
                    [_delegate loadGoodsInfoDataSucceed];
                }
            }
        }];
        
    }
    
}


@end
