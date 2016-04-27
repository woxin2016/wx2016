//
//  SignModel.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "SignModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "WXTURLFeedOBJ.h"
#import "SignEntity.h"
#import "MoreMoneyInfoModel.h"

@interface SignModel(){
    NSMutableArray *_signArr;
}
@end

@implementation SignModel

-(id)init{
    self = [super init];
    if(self){
        _signArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseClassifyData:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    SignEntity *entity = [SignEntity signWithDictionary:dic];
    [_signArr addObject:entity];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:[UtilTool timeChange] forKey:userObj.wxtID];
    
    NSString *message = [NSString stringWithFormat:@"今日签到领取了%.2f元",entity.money];
    if(entity.type == 2){
        message = [NSString stringWithFormat:@"今日签到领取了%d云票",(int)entity.money];
        
        //通知云票数量已经发生变化
        [MoreMoneyInfoModel shareUserMoreMoneyInfo].userCloudBalance += (int)entity.money;
        [MoreMoneyInfoModel shareUserMoreMoneyInfo].isChanged = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_UserCloudTicketChanged object:nil];
    }
    NSUserDefaults *userDefault1 = [NSUserDefaults standardUserDefaults];
    [userDefault1 setObject:message forKey:userObj.user];
}

-(void)signGainMoney{
    [_signArr removeAllObjects];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.sellerID, @"sid", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.user, @"phone", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.sellerID, @"sid", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_Sign httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        __block SignModel *blockSelf = self;
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(signFailed:)]){
                [_delegate signFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseClassifyData:[retData.data objectForKey:@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(signSucceed)]){
                [_delegate signSucceed];
            }
        }
    }];
}

@end
