//
//  MoreMoneyInfoModel.m
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "MoreMoneyInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation MoreMoneyInfoModel

-(id)init{
    self = [super init];
    if(self){
        _userCloudBalance = 0;
        _userMoneyBalance = 0;
    }
    return self;
}

+(MoreMoneyInfoModel*)shareUserMoreMoneyInfo{
    static dispatch_once_t onceToken;
    static MoreMoneyInfoModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self shareUserMoreMoneyInfo];
}

-(void)loadUserMoreMoneyInfo{
    _isLoaded = NO;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.wxtID, @"woxin_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.wxtID, @"woxin_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_MoreMoneyInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            _isLoaded = NO;
        }else{
            _isLoaded = YES;
            _userCloudBalance = [[[retData.data objectForKey:@"data"] objectForKey:@"xnb_1"] integerValue];
            _userMoneyBalance = [[[retData.data objectForKey:@"data"] objectForKey:@"balance"] floatValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_LoadUserMoreMoneyInfoSucceed object:nil];
        }
    }];
}

@end
