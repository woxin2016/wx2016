//
//  RechargeCTModel.m
//  RKWXT
//
//  Created by SHB on 16/4/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "RechargeCTModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "MoreMoneyInfoModel.h"

@implementation RechargeCTModel

-(void)rechargeUserCloudTicketWith:(NSString *)cartID andPwd:(NSString *)pwd completion:(void (^)(NSInteger, NSString *))completion{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.wxtID, @"woxin_id", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", cartID, @"card_id", pwd, @"card_pwd", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.wxtID, @"woxin_id", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", cartID, @"card_id", pwd, @"card_pwd", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_RechargeCt httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code == 0){
            //通知云票数量已经发生变化
            [MoreMoneyInfoModel shareUserMoreMoneyInfo].userCloudBalance += [[[retData.data objectForKey:@"data"] objectForKey:@"xnb_money"] integerValue];
            [MoreMoneyInfoModel shareUserMoreMoneyInfo].isChanged = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_UserCloudTicketChanged object:nil];
        }
        completion(retData.code,retData.errorDesc);
    }];
}

@end
