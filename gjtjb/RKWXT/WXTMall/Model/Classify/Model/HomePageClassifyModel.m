//
//  HomePageClassifyModel.m
//  RKWXT
//
//  Created by SHB on 16/3/31.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomePageClassifyModel.h"
#import "HomePageClassifyEntity.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface HomePageClassifyModel(){
    NSMutableArray *_dataList;
}
@end

@implementation HomePageClassifyModel
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

-(void)fillDataWithJsonData:(NSArray*)jsonDicData{
    if(!jsonDicData){
        return;
    }
    [_dataList removeAllObjects];
    for(NSDictionary *dic in jsonDicData){
        HomePageClassifyEntity *entity = [HomePageClassifyEntity initClassifyEntityWithDic:dic];
        entity.cat_img = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.cat_img];
        [_dataList addObject:entity];
    }
}

-(void)loadDataFromWeb{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.shopID, @"shop_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.shopID, @"shop_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block HomePageClassifyModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Classify httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageClassifyLoadedFailed:)]){
                [_delegate homePageClassifyLoadedFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf fillDataWithJsonData:[retData.data objectForKey:@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(homePageClassifyLoadedSucceed)]){
                [_delegate homePageClassifyLoadedSucceed];
            }
        }
    }];
}

-(void)loadCacheDataSucceed{
    if(_delegate && [_delegate respondsToSelector:@selector(homePageClassifyLoadedSucceed)]){
        [_delegate homePageClassifyLoadedSucceed];
    }
}

@end