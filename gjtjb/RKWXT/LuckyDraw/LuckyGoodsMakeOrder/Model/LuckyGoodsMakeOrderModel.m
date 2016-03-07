//
//  LuckyGoodsMakeOrderModel.m
//  RKWXT
//
//  Created by SHB on 15/8/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsMakeOrderModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "NewUserAddressModel.h"
#import "AreaEntity.h"

@interface LuckyGoodsMakeOrderModel(){
}

@end

@implementation LuckyGoodsMakeOrderModel

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

-(void)luckyGoodsMakeOrderWith:(NSInteger)lottery_id WithMoney:(CGFloat)money{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    AreaEntity *entity = [self addressEntity];
    if(!entity){
        if (_delegate && [_delegate respondsToSelector:@selector(luckyGoodsMakeOrderFailed:)]){
            [_delegate luckyGoodsMakeOrderFailed:@"请设置收货信息"];
        }
        return;
    }
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",entity.proName,entity.cityName,entity.disName,entity.address];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.sellerID, @"sid", userObj.user, @"phone", [NSNumber numberWithInteger:lottery_id], @"lottery_id", userObj.wxtID, @"woxin_id", [NSNumber numberWithFloat:money], @"total_fee", address, @"address", entity.userName, @"consignee", entity.userPhone, @"telephone", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.sellerID, @"sid", userObj.user, @"phone", [NSNumber numberWithInteger:lottery_id], @"lottery_id", userObj.wxtID, @"woxin_id", [NSNumber numberWithFloat:money], @"total_fee", address, @"address", entity.userName, @"consignee", entity.userPhone, @"telephone", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LuckyMakeOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(luckyGoodsMakeOrderFailed:)]){
                [_delegate luckyGoodsMakeOrderFailed:retData.errorDesc];
            }
        }else{
            [self setOrderID:[[retData.data objectForKey:@"data"] objectForKey:@"order_id"]];
            if(_delegate && [_delegate respondsToSelector:@selector(luckyGoodsMakeOrderSucceed)]){
                [_delegate luckyGoodsMakeOrderSucceed];
            }
        }
    }];
}

-(AreaEntity *)addressEntity{
    if([[NewUserAddressModel shareUserAddress].userAddressArr count] == 0){
        return nil;
    }
    AreaEntity *entity = nil;
    for(AreaEntity *ent in [NewUserAddressModel shareUserAddress].userAddressArr){
        if(ent.normalID == 1){
            entity = ent;
        }
    }
    return entity;
}

@end
