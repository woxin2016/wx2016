//
//  GoodsAttentionModel.m
//  RKWXT
//
//  Created by app on 16/3/22.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "GoodsAttentionModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "CollectionGoodsEntity.h"

@implementation GoodsAttentionModel

- (NSMutableArray*)goodsArr{
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

+ (instancetype)goodsAttentionModelAlloc{
    static GoodsAttentionModel *model = nil;
    static dispatch_once_t onceUser;
    dispatch_once(&onceUser, ^{
        model = [[GoodsAttentionModel alloc]init];
    });
    return model;
}

/*
 接口名称:收藏商品和店铺
 接口地址:https://oldyun.67call.com/wx10api/V1/stores.php
 请求方式:POST
 输入参数:
 pid:平台类型(android,ios),
 ts:时间戳,
 woxin_id:我信ID
 type : 操作类型 1添加收藏  2收藏列表  3删除收藏 4是否已经收藏
 store_type: 收藏类型  1收藏商品(店铺=0)  2收藏店铺(商品=0)
 goods_id:商品ID
 store_shop_id : 店铺ID
 sign: 签名
 返回数据格式:json
 成功返回: error :0  data:数据
 失败返回:error :1  msg:错误信息
 */

//查看该商品是否已经收藏
-(void)searchGoodsPayAttention:(NSInteger)goodsID shopID:(NSInteger)shopID requestType:(GoodsAttentionModel_Type)type likeType:(GoodsAttentionModel_likeType)likeType{
     WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"type"]= [NSNumber numberWithInt:type];
    baseDic[@"store_type"]= [NSNumber numberWithInt:likeType];
    baseDic[@"goods_id"]= [NSNumber numberWithInteger:goodsID];
    baseDic[@"store_shop_id"]= [NSNumber numberWithInteger:0];
   
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"type"]= [NSNumber numberWithInt:type];
    dic[@"store_type"]= [NSNumber numberWithInt:likeType];
    dic[@"goods_id"]= [NSNumber numberWithInteger:goodsID];
    dic[@"store_shop_id"]= [NSNumber numberWithInteger:0];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
 
    __block typeof(self) blockSelf = self;
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_PayAttention httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_GoodsAttentionModelFailed object:retData.errorDesc];
        }else{
            
            if (likeType == GoodsAttentionModel_likeType_Goods) {  // 收藏商品
                
                if (type == GoodsAttentionModel_Type_addGoods) {  // 添加商品
                    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_GoodsAttentionModelAddGoods object:retData.data[@"data"]];
                }else if (type == GoodsAttentionModel_Type_goodsList){ //商品列表
                    
                    [blockSelf parsingSuccendData:retData.data[@"data"]];
                    
                }else if (type == GoodsAttentionModel_Type_isQueryGoods){ //查询商品是否被收藏
                    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_GoodsAttentionModelIsAttention object:retData.data[@"data"]];
                }else if (type == GoodsAttentionModel_Type_removeGoods){  //删除收藏商品
                    
                }
                
            }else{  // 收藏店铺
                
            }
            
         
        }
    }];
}


- (void)parsingSuccendData:(NSArray*)data{
    if (!data) return;
    [self.goodsArr removeAllObjects];
    
    for (NSDictionary *dic in data) {
        CollectionGoodsEntity *entity = [CollectionGoodsEntity collectionGoodsEntity:dic];
        [self.goodsArr addObject:entity];
    }
   [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_GoodsAttentionModelSucceed object:self];
}


-(void)deleteGoodsID:(NSInteger)deleteID requestType:(GoodsAttentionModel_Type)type likeType:(GoodsAttentionModel_likeType)likeType{
    
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"type"]= [NSNumber numberWithInt:type];
    baseDic[@"store_type"]= [NSNumber numberWithInt:likeType];
    baseDic[@"goods_id"]= [NSNumber numberWithInteger:0];
    baseDic[@"store_shop_id"]= [NSNumber numberWithInteger:0];
    baseDic[@"store_id"] = [NSNumber numberWithInteger:deleteID];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"type"]= [NSNumber numberWithInt:type];
    dic[@"store_type"]= [NSNumber numberWithInt:likeType];
    dic[@"goods_id"]= [NSNumber numberWithInteger:0];
    dic[@"store_shop_id"]= [NSNumber numberWithInteger:0];
    dic[@"store_id"] = [NSNumber numberWithInteger:deleteID];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];

    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_PayAttention httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_GoodsAttentionModelFailed object:retData.errorDesc];
        }else{
            
            if (likeType == GoodsAttentionModel_likeType_Goods) {  // 删除商品
             
                if (type == GoodsAttentionModel_Type_removeGoods){  //删除收藏商品
                    [[NSNotificationCenter defaultCenter]postNotificationName:K_Notification_Name_GoodsAttentionModelDeleteSucceed object:nil];
                }
                
            }else{  // 删除店铺
            
                
            }
            
            
        }
    }];

    
    
}


@end
