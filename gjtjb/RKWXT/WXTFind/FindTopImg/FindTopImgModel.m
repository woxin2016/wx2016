//
//  FindTopImgModel.m
//  RKWXT
//
//  Created by SHB on 16/4/12.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "FindTopImgModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "HomePageTopEntity.h"

@interface FindTopImgModel(){
    NSMutableArray *_imgArr;
}
@end

@implementation FindTopImgModel
@synthesize imgArr = _imgArr;

-(id)init{
    self = [super init];
    if(self){
        _imgArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)toInit{
    [super toInit];
    [_imgArr removeAllObjects];
}

-(void)fillDataWithJsonData:(NSDictionary *)jsonDicData{
    if(!jsonDicData){
        return;
    }
    [_imgArr removeAllObjects];
    NSArray *datalist = [jsonDicData objectForKey:@"data"];
    for(NSDictionary *dic in datalist){
        HomePageTopEntity *entity = [HomePageTopEntity homePageTopEntityWithDictionary:dic];
        entity.topImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.topImg];
        if(entity.position == 1){
            [_imgArr addObject:entity];
        }
    }
    _imgArr = [NSMutableArray arrayWithArray:[self recordDataClassifyTypeUpSort]];
}

//升序排序
-(NSArray*)recordDataClassifyTypeUpSort{
    NSArray *sortArray = [_imgArr sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        HomePageTopEntity *entity_0 = obj1;
        HomePageTopEntity *entity_1 = obj2;
        
        if (entity_0.sortID < entity_1.sortID){
            return NSOrderedDescending;
        }else if (entity_0.sortID > entity_1.sortID){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return sortArray;
}

-(void)loadFindTopImgData{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.shopID, @"shop_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.shopID, @"shop_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block FindTopImgModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_TopImg httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(findTopImgLoadedFailed:)]){
                [_delegate findTopImgLoadedFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf fillDataWithJsonData:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(findTopImgLoadedSucceed)]){
                [_delegate findTopImgLoadedSucceed];
            }
        }
    }];
}

-(void)loadCacheDataSucceed{
    if (_delegate && [_delegate respondsToSelector:@selector(findTopImgLoadedSucceed)]){
        [_delegate findTopImgLoadedSucceed];
    }
}

@end
