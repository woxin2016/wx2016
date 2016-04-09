//
//  UserMoneyFormModel.m
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserMoneyFormModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "UserMoneyFormEntity.h"

@interface UserMoneyFormModel(){
    NSMutableArray *_moneyFormArr;
}

@end

@implementation UserMoneyFormModel
@synthesize moneyFormArr = _moneyFormArr;

-(id)init{
    self = [super init];
    if(self){
        _moneyFormArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseUserMoneyFormData:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_moneyFormArr removeAllObjects];
    UserMoneyFormEntity *entity = [UserMoneyFormEntity initUserMoneyFormEntity:dic];
    [_moneyFormArr addObject:entity];
}

-(void)loadUserMoneyFormData{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.wxtID, @"woxin_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.wxtID, @"woxin_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block UserMoneyFormModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_UserMoneyForm httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadUserMoneyFormDataFailed:)]){
                [_delegate loadUserMoneyFormDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseUserMoneyFormData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadUserMoneyFormDataSucceed)]){
                [_delegate loadUserMoneyFormDataSucceed];
            }
        }
    }];
}

@end
