//
//  UserHeaderModel.m
//  RKWXT
//
//  Created by SHB on 15/9/9.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserHeaderModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation UserHeaderModel

+(UserHeaderModel*)shareUserHeaderModel{
    static dispatch_once_t onceToken;
    static UserHeaderModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[UserHeaderModel alloc] init];
    });
    return sharedInstance;
}

-(void)loadUserHeaderImageWith{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"iOS", @"pid",
                             [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                             userObj.wxtID, @"woxin_id",
                             nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"iOS", @"pid",
                         [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                         userObj.wxtID, @"woxin_id",
                         [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign",
                         nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadUserHeader httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
        }else{
            NSString *pic = [[retData.data objectForKey:@"data"] objectForKey:@"pic"];
            [self setUserHeaderImg:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,pic]];
        }
    }];
}

-(void)updateUserHeaderSucceed:(NSString *)headerPath{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *pwdStr = [UtilTool md5:userObj.pwd];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"iOS", @"pid",
                         [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                         headerPath, @"pic_name",
                         userObj.wxtID, @"woxin_id",
                         pwdStr, @"pwd",
                         nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"iOS", @"pid",
                         [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                         headerPath, @"pic_name",
                         userObj.wxtID, @"woxin_id",
                         pwdStr, @"pwd",
                         [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign",
                         nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_UpdateUserHeader httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
    }];
}

@end
