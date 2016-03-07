//
//  LuckyOrderListModel.m
//  RKWXT
//
//  Created by SHB on 15/8/19.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyOrderListModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LuckyOrderEntity.h"

@interface LuckyOrderListModel(){
    NSMutableArray *_luckyOrderListArr;
    NSInteger number;
}

@end

@implementation LuckyOrderListModel
@synthesize luckyOrderListArr = _luckyOrderListArr;

-(id)init{
    self = [super init];
    if(self){
        _luckyOrderListArr = [[NSMutableArray alloc] init];
    }
    return self;
}

+(LuckyOrderListModel*)shareLuckyOrderList{
    static dispatch_once_t onceToken;
    static LuckyOrderListModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[LuckyOrderListModel alloc] init];
    });
    return sharedInstance;
}

-(void)parseLuckyOrderListWidthDic:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    if(number == 0){
        [_luckyOrderListArr removeAllObjects];
    }

    NSArray *arr = [[dic objectForKey:@"data"] objectForKey:@"order"];
    for(NSDictionary *dictionary in arr){
        LuckyOrderEntity *entity = [LuckyOrderEntity initLuckyOrderEntityWidthDic:dictionary];
        entity.goods_img = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.goods_img];
        entity.sellerPhone = [[dic objectForKey:@"data"] objectForKey:@"services"];
        [_luckyOrderListArr addObject:entity];
    }
}

-(void)loadLuckyOrderListWithStrat:(NSInteger)startItem withLength:(NSInteger)lenth{
    number = startItem;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.user, @"phone", userObj.sellerID, @"sid", [NSNumber numberWithInteger:startItem], @"start_item", [NSNumber numberWithInteger:lenth], @"length", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.user, @"phone", userObj.sellerID, @"sid", [NSNumber numberWithInteger:startItem], @"start_item", [NSNumber numberWithInteger:lenth], @"length", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block LuckyOrderListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LuckyOrderList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_LuckyOrderList_LoadFailed object:retData.errorDesc];
        }else{
            [blockSelf parseLuckyOrderListWidthDic:retData.data];
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_LuckyOrderList_LoadSucceed object:nil];
        }
    }];
}

@end