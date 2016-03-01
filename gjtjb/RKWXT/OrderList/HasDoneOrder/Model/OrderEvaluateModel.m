//
//  OrderEvaluateModel.m
//  RKWXT
//
//  Created by SHB on 16/3/1.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "OrderEvaluateModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation OrderEvaluateModel

-(void)userEvaluateOrder:(NSInteger)orderID andInfo:(NSString *)content type:(OrderEvaluate_Type)type{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:type], @"type", content, @"evaluate", [NSNumber numberWithInt:orderID], @"order_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:type], @"type", content, @"evaluate", [NSNumber numberWithInt:orderID], @"order_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_OrderEvaluate httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(orderEvaluateFailed:)]){
                [_delegate orderEvaluateFailed:retData.errorDesc];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(orderEvaluateSucceed)]){
                [_delegate orderEvaluateSucceed];
            }
        }
    }];
}

@end
