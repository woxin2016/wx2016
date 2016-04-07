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
    NSMutableArray *_weekCTListArr;
    NSMutableArray *_monthCTListArr;
    NSMutableArray *_allCTListArr;
}

@end

@implementation UserCloudTicketModel
@synthesize weekCTListArr = _weekCTListArr;
@synthesize monthCTListArr = _monthCTListArr;
@synthesize allCTListArr = _allCTListArr;

-(id)init{
    self = [super init];
    if(self){
        _weekCTListArr = [[NSMutableArray alloc] init];
        _monthCTListArr = [[NSMutableArray alloc] init];
        _allCTListArr = [[NSMutableArray alloc] init];
    }
    return self;
}

+(UserCloudTicketModel*)sharedUserCloudTicket{
    static dispatch_once_t onceTocken;
    static UserCloudTicketModel *sharedInstance = nil;
    dispatch_once(&onceTocken,^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self sharedUserCloudTicket];
}

-(void)parseUserCloudTicketData:(NSArray*)arr{
    if(!arr){
        return;
    }
    [_weekCTListArr removeAllObjects];
    [_monthCTListArr removeLastObject];
    [_allCTListArr removeAllObjects];
    for(NSDictionary *dic in arr){
//        UserCloudTicketEntity *entity = [UserCloudTicketEntity initUserCloudTicketEntityWith:dic];
//        [_weekCTListArr addObject:entity];
    }
}

-(void)loadUserCloudTicketData{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.sellerID, @"sid", userObj.shopID, @"shop_id", userObj.wxtID, @"woxin_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.sellerID, @"sid", userObj.shopID, @"shop_id", userObj.wxtID, @"woxin_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block UserCloudTicketModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_UserBonus httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_LoadUserCloudTicketFailed object:retData.errorDesc];
        }else{
            [blockSelf parseUserCloudTicketData:[retData.data objectForKey:@"data"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_LoadUserCloudTicketSucceed object:nil];
        }
    }];
}

@end
