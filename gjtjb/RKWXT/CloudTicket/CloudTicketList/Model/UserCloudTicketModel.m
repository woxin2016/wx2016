//
//  UserCloudTicketModel.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserCloudTicketModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "UserCloudTicketEntity.h"

@interface UserCloudTicketModel(){
    NSMutableArray *_userCloudArr;
    NSInteger _startItem;
}

@end

@implementation UserCloudTicketModel
@synthesize userCloudArr = _userCloudArr;

-(id)init{
    self = [super init];
    if(self){
        _userCloudArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseUserCloudTicketData:(NSArray*)arr{
    if(!arr){
        return;
    }
    if(_startItem == 0){
        [_userCloudArr removeAllObjects];
    }
//    for(NSDictionary *dic in arr){
//        UserCloudTicketEntity *entity = [UserCloudTicketEntity initUserCloudTicketEntityWith:dic];
//        [_weekCTListArr addObject:entity];
//    }
}

-(void)loadUserCloudTicketData:(NSInteger)startItem length:(NSInteger)length type:(UserCloudTicket_Type)type{
    _startItem = startItem;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.sellerID, @"sid", userObj.shopID, @"shop_id", userObj.wxtID, @"woxin_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.sellerID, @"sid", userObj.shopID, @"shop_id", userObj.wxtID, @"woxin_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block UserCloudTicketModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_UserBonus httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadUserCloudTicketDataFailed:)]){
                [_delegate loadUserCloudTicketDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseUserCloudTicketData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadUserCloudTicketDataSucceed)]){
                [_delegate loadUserCloudTicketDataSucceed];
            }
        }
    }];
}

@end
