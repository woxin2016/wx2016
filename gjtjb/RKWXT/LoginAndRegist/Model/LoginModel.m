//
//  LoginModel.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LoginModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation LoginModel

-(void)loginWithUser:(NSString *)userStr pwd:(NSString *)pwdStr completion:(void (^)(NSInteger, NSString *))completion{
    NSString *pwdString = [UtilTool md5:pwdStr];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userStr, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", pwdString, @"pwd", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userStr, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", pwdString, @"pwd", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Login httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        NSDictionary *dic = retData.data;
        if (retData.code == 0){
            WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
            [userDefault setUser:userStr];
            [userDefault setPwd:pwdStr];
            [userDefault setWxtID:[[dic objectForKey:@"data"] objectForKey:@"woxin_id"]];
            [userDefault setSellerID:[[dic objectForKey:@"data"] objectForKey:@"seller_id"]]; //用户所属商家id
            [userDefault setSellerName:[[dic objectForKey:@"data"] objectForKey:@"seller_name"]]; //用户所属商家
            [userDefault setShopID:[[dic objectForKey:@"data"] objectForKey:@"shop_id"]]; //用户所在店铺id
            [userDefault setShopName:[[dic objectForKey:@"data"] objectForKey:@"shop_name"]]; //用户所在店铺
            [userDefault setNickname:[[dic objectForKey:@"data"] objectForKey:@"nickname"]]; //用户昵称
            [userDefault setUserIdentity:[[dic objectForKey:@"data"] objectForKey:@"is_sale"]]; //是否为特殊用户
        }
        completion(retData.code,retData.errorDesc);
    }];

}

@end
