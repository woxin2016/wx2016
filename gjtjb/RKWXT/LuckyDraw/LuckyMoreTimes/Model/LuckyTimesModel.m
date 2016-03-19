//
//  LuckyTimesModel.m
//  RKWXT
//
//  Created by SHB on 16/3/19.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "LuckyTimesModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation LuckyTimesModel

-(void)luckyTimesChangeWithNumber:(NSInteger)num completion:(void (^)(NSDictionary *))completion{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.sellerID, @"sid", userObj.wxtID, @"woxin_id", userObj.user, @"phone", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.sellerID, @"sid", userObj.wxtID, @"woxin_id", userObj.user, @"phone", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LuckyTimes httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        completion(retData.data);
    }];
}

@end
