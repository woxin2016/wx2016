//
//  LuckyGoodsOrderInfoModel.m
//  RKWXT
//
//  Created by SHB on 16/3/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "LuckyGoodsOrderInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LuckyOrderListModel.h"
#import "LuckyOrderEntity.h"

@implementation LuckyGoodsOrderInfoModel

-(void)completeLuckyOrderWith:(NSInteger)orderID{
    //    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInteger:[UtilTool timeChange]], @"ts", [NSNumber numberWithInteger:orderID], @"order_id", userObj.wxtID, @"woxin_id", userObj.sellerID, @"seller_user_id", userObj.user, @"phone", userObj.sellerID, @"sid", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", nil];
    //    __block LuckyGoodsInfoModel *blockSelf = self;
    //    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_CompleteLuckyOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
    //        if(retData.code != 0){
    //            if(_delegate && [_delegate respondsToSelector:@selector(completeLuckyOrderFailed:)]){
    //                [_delegate completeLuckyOrderFailed:retData.errorDesc];
    //            }
    //        }else{
    //            [blockSelf changeLuckyOrderStatus:orderID];
    //            if(_delegate && [_delegate respondsToSelector:@selector(completeLuckyOrderSucceed)]){
    //                [_delegate completeLuckyOrderSucceed];
    //            }
    //        }
    //    }];
}

-(void)changeLuckyOrderStatus:(NSInteger)orderID{
    if(orderID==0){
        return;
    }
    for(LuckyOrderEntity *entity in [LuckyOrderListModel shareLuckyOrderList].luckyOrderListArr){
        if(entity.order_id == orderID){
            entity.order_status = LuckyOrder_Status_Done;
            return;
        }
    }
}

@end
