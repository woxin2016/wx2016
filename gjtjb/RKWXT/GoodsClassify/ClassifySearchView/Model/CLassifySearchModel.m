//
//  CLassifySearchModel.m
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "CLassifySearchModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "SearchResultEntity.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "NSObject+SBJson.h"

@interface CLassifySearchModel(){
    NSMutableArray *_searchResultArr;
}
@end

@implementation CLassifySearchModel
@synthesize searchResultArr = _searchResultArr;

-(id)init{
    self = [super init];
    if(self){
        _searchResultArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseSearchResultWith:(id)arr{
    [_searchResultArr removeAllObjects];
    if([arr isKindOfClass:[NSString class]]){
        return;
    }
    for(NSDictionary *dic in arr){
        SearchResultEntity *entity = [SearchResultEntity initSearchResultEntityWith:dic];
        [_searchResultArr addObject:entity];
    }
}

/*
 接口地址：https://oldyun.67call.com/wx10api/search.php
 请求方式：POST
 输入参数：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 woxin_id : 我信ID
 type: 1.商品，2.店铺
 sid:商家ID
 shop_id:店铺ID
 keyword:关键字
 sign: 签名
 
 */

-(void)classifySearchWith:(NSString *)searchStr{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"type"]= [NSNumber numberWithInt:(int)_searchType];
    baseDic[@"sid"]= userObj.sellerID;
    baseDic[@"shop_id"]= userObj.shopID;
    baseDic[@"keyword"]= searchStr;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"type"]= [NSNumber numberWithInt:(int)_searchType];
    dic[@"sid"]= userObj.sellerID;
    dic[@"shop_id"]= userObj.shopID;
    dic[@"keyword"]= searchStr;
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    
    
    __block CLassifySearchModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_SearchGoodsOrShop httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(classifySearchResultFailure:)]) {
                [_delegate classifySearchResultFailure:retData.errorDesc];
            }
        }else{
            [blockSelf parseSearchResultWith:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(classifySearchResultSucceed)]){
                [_delegate classifySearchResultSucceed];
            }
        }
    }];
}

@end
