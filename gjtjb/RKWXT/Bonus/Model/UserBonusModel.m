//
//  UserBonusModel.m
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserBonusModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "UserBonusEntity.h"

@interface UserBonusModel(){
    NSMutableArray *_userBonusArr;
    NSMutableArray *_denyBonusArr;
    NSMutableArray *_receiveIDArr;
}
@end

@implementation UserBonusModel
@synthesize userBonusArr = _userBonusArr;

+(UserBonusModel*)shareUserBonusModel{
    static dispatch_once_t onceToken;
    static UserBonusModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self shareUserBonusModel];
}

-(id)init{
    self = [super init];
    if(self){
        _userBonusArr = [[NSMutableArray alloc] init];
        _denyBonusArr = [[NSMutableArray alloc] init];
        _receiveIDArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)toInit{
    [super toInit];
    [_userBonusArr removeAllObjects];
    [_denyBonusArr removeAllObjects];
    [_receiveIDArr removeAllObjects];
}

-(BOOL)shouldDataReload{
    return self.status == E_ModelDataStatus_Init || self.status == E_ModelDataStatus_LoadFailed;
}

//获取红包余额
-(void)loadUserBonusMoney{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.sellerID, @"sid", userObj.shopID, @"shop_id", userObj.wxtID, @"woxin_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.sellerID, @"sid", userObj.shopID, @"shop_id", userObj.wxtID, @"woxin_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
//    __block UserBonusModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadUserBonus httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            _bonusMoney = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserBonus_UserBonusFailed object:retData.errorDesc];
        }else{
            NSDictionary *dataDic = [retData.data objectForKey:@"data"];
            _bonusMoney = [[dataDic objectForKey:@"red_packet"] integerValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserBonus_UserBonusSucceed object:nil];
        }
    }];
}

//加载所有红包
-(void)loadUserBonus{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.sellerID, @"sid", userObj.shopID, @"shop_id", userObj.wxtID, @"woxin_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", userObj.sellerID, @"sid", userObj.shopID, @"shop_id", userObj.wxtID, @"woxin_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block UserBonusModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_UserBonus httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserBonus_LoadDateFailed object:retData.errorDesc];
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf parseUserBonusWithDic:[retData.data objectForKey:@"data"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserBonus_LoadDateSucceed object:nil];
        }
    }];
}

-(void)parseUserBonusWithDic:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_userBonusArr removeAllObjects];
    [_denyBonusArr removeAllObjects];
    [_receiveIDArr removeAllObjects];
    
    
    id receiveArr = [dic objectForKey:@"receive"];  //已经领取的红包
    if([receiveArr isKindOfClass:[NSArray class]]){
        for(NSDictionary *receiveDic in receiveArr){
            NSString *receiveID = [NSString stringWithFormat:@"%ld",(long)[[receiveDic objectForKey:@"red_packet_id"] integerValue]];
            [_receiveIDArr addObject:receiveID];
        }
    }
    
    NSArray *bonusArr = [dic objectForKey:@"red_packet"];  //所有红包
    for(NSDictionary *dictionary in bonusArr){
        UserBonusEntity *entity = [UserBonusEntity initUserBonusEntityWithDictionary:dictionary];
        if([self isValidBonus:entity]){
            [_userBonusArr addObject:entity]; //可领取
        }else{
            [_denyBonusArr addObject:entity];
        }
    }
    [self changeTurnForAllBonusArr:_userBonusArr];
    [self changeTurnForAllBonusArr:_denyBonusArr];
}

-(void)changeTurnForAllBonusArr:(NSMutableArray*)arr{
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UserBonusEntity *item1 = obj1;
        UserBonusEntity *item2 = obj2;
        if (item1.bonusValue > item2.bonusValue){
            return NSOrderedDescending;
        }else if (item1.bonusValue == item2.bonusValue){
            return NSOrderedSame;
        }else{
            return NSOrderedAscending;
        }
    }];
}

-(BOOL)isValidBonus:(UserBonusEntity*)ent{
    BOOL isValid = YES;
    if(ent.begin_time < [UtilTool timeChange] && ent.end_time > [UtilTool timeChange]){
        for(NSString *recID in _receiveIDArr){
            if(ent.bonusID == [recID integerValue]){
                return NO;
            }
        }
    }else{
        return NO;
    }
    
    return isValid;
}

//领取红包
-(void)gainUserBonus:(NSInteger)bonusID withBonusMoney:(NSInteger)money{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", [NSNumber numberWithInteger:bonusID], @"red_packet_id", userObj.sellerID, @"sid", userObj.shopID, @"shop_id", userObj.wxtID, @"woxin_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", [NSNumber numberWithInteger:bonusID], @"red_packet_id", userObj.sellerID, @"sid", userObj.shopID, @"shop_id", userObj.wxtID, @"woxin_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block UserBonusModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_GainBonus httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserBonus_GainBonusFailed object:retData.errorDesc];
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf gainUserBonusSucceed:[[[retData.data objectForKey:@"data"] objectForKey:@"red_packet_id"] integerValue] withMoney:money];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_UserBonus_GainBonusSucceed object:nil];
        }
    }];
}

-(void)gainUserBonusSucceed:(NSInteger)bonusID withMoney:(NSInteger)money{
    if(bonusID<=0){
        return;
    }
    NSArray *oldArr = _userBonusArr;
    _bonusMoney += money;
    for(UserBonusEntity *entity in oldArr){
        if(entity.bonusID == bonusID){
            [_userBonusArr removeObject:entity];
            [_denyBonusArr addObject:entity];
            break;
        }
    }
    [self changeTurnForAllBonusArr:_denyBonusArr];
}

@end