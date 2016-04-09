//
//  UserMoneyInfoModel.m
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserMoneyInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "UserMoneyInfoEntity.h"

@interface UserMoneyInfoModel(){
    NSMutableArray *_userMoneyInfoArr;
    NSInteger _startItem;
}

@end

@implementation UserMoneyInfoModel
@synthesize userMoneyInfoArr = _userMoneyInfoArr;

-(id)init{
    self = [super init];
    if(self){
        _userMoneyInfoArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseUserMoneyInfoData:(NSArray*)arr{
    if(!arr){
        return;
    }
    if(_startItem == 0){
        [_userMoneyInfoArr removeAllObjects];
    }
    for(NSDictionary *dic in arr){
        UserMoneyInfoEntity *entity = [UserMoneyInfoEntity initUserMoneyInfoEntity:dic];
        [_userMoneyInfoArr addObject:entity];
    }
}

-(void)loadUserMoneyInfoData:(NSInteger)startItem length:(NSInteger)length days:(NSInteger)days{
    _startItem = startItem;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:days], @"days", [NSNumber numberWithInt:startItem], @"start_item", [NSNumber numberWithInt:length], @"length", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:days], @"days", [NSNumber numberWithInt:startItem], @"start_item", [NSNumber numberWithInt:length], @"length", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block UserMoneyInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_UserMoneyInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadUserCloudTicketDataFailed:)]){
                [_delegate loadUserCloudTicketDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseUserMoneyInfoData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadUserCloudTicketDataSucceed)]){
                [_delegate loadUserCloudTicketDataSucceed];
            }
        }
    }];
}

@end
