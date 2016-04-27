//
//  ShareInfoModel.m
//  RKWXT
//
//  Created by SHB on 16/3/1.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "ShareInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation ShareInfoModel

+(ShareInfoModel*)shareInfoModel{
    static dispatch_once_t onceToken;
    static ShareInfoModel *shareInstance = nil;
    dispatch_once(&onceToken,^{
        shareInstance = [[ShareInfoModel alloc] init];
    });
    return shareInstance;
}

-(void)loadUserShareInfo{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.sellerID, @"sid", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.sellerID, @"sid", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_ShareInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code == 0){
            WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
            [userObj setShareInfo:[[retData.data objectForKey:@"data"] objectForKey:@"app_share_info"]];
        }
    }];
}

-(void)loadUserShareCutInfo{
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", @"invite_info", @"vname", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", @"invite_info", @"vname", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_ShareCutInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code == 0){
            WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
            [userObj setShareUserCutInfo:[[retData.data objectForKey:@"data"] objectForKey:@"value"]];
        }
    }];
}

@end
