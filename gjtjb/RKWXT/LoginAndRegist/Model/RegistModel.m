//
//  RegistModel.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RegistModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation RegistModel

-(void)registWithUserPhone:(NSString *)userStr andPwd:(NSString *)pwdStr andSmsID:(NSInteger)smsID andCode:(NSInteger)code andRecommondUser:(NSString *)recommondUserStr{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userStr, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:pwdStr],@"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", recommondUserStr, @"referrer", userObj.sellerID, @"sid", [NSNumber numberWithInt:(int)code], @"rcode", [NSNumber numberWithInt:(int)smsID], @"rand_id", nil];
//    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
//    baseDic[@"pid"] = @"ios";
//    baseDic[@"phone"] = userStr;
//    baseDic[@"pwd"] = [UtilTool newStringWithAddSomeStr:5 withOldStr:pwdStr];
//    baseDic[@"ts"] = [NSNumber numberWithInt:(int)[UtilTool timeChange]];
//    baseDic[@"ver"] = [UtilTool currentVersion];
//    //    dict[@"referrer"] = recommondUserStr;
//    baseDic[@"sid"] = [NSNumber numberWithInt:(int)kMerchantID];
//    baseDic[@"rcode"] = [NSNumber numberWithInt:(int)code];
//    baseDic[@"rand_id"] = [NSNumber numberWithInt:(int)smsID];
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"pid"]= @"ios";
//    dic[@"phone"]= userStr;
//    dic[@"pwd"] = [UtilTool newStringWithAddSomeStr:5 withOldStr:pwdStr];
//    dic[@"ts"] = [NSNumber numberWithInt:(int)[UtilTool timeChange]];
//    dic[@"ver"] = [UtilTool currentVersion];
//    //    dict[@"referrer"] = recommondUserStr;
//    dic[@"sid"] = [NSNumber numberWithInt:(int)kMerchantID];
//    dic[@"rcode"] = [NSNumber numberWithInt:(int)code];
//    dic[@"rand_id"] = [NSNumber numberWithInt:(int)smsID];
//    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Regist httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(registFailed:)]){
                [_delegate registFailed:retData.errorDesc];
            }
        }else{
            WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
            [userObj setUser:userStr];
            if (_delegate && [_delegate respondsToSelector:@selector(registSucceed)]){
                [_delegate registSucceed];
            }
        }
    }];
}

@end
