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

-(void)luckyTimesChangeWithNumber:(NSInteger)num type:(LuckyTimes_ReaquestType)type completion:(void (^)(NSDictionary *))completion{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.user, @"phone",[NSNumber numberWithInt:type],@"type",[NSNumber numberWithInteger:num],@"exchange_number",[UtilTool md5:userObj.pwd],@"pwd",nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.user, @"phone", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign",[NSNumber numberWithInt:type],@"type",[NSNumber numberWithInteger:num],@"exchange_number",[UtilTool md5:userObj.pwd],@"pwd", nil];
   
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LuckyTimes httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
       
        if (retData.code != 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:D_Notification_Name_LuckyTimesModel_Failed object:retData.errorDesc];
        }else{
           completion(retData.data);
        }
        
    }];
}

@end
