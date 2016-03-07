//
//  LuckyOrderListModel.h
//  RKWXT
//
//  Created by SHB on 15/8/19.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

#define D_Notification_Name_LuckyOrderList_LoadSucceed @"D_Notification_Name_LuckyOrderList_LoadSucceed"
#define D_Notification_Name_LuckyOrderList_LoadFailed  @"D_Notification_Name_LuckyOrderList_LoadFailed"

@interface LuckyOrderListModel : T_HPSubBaseModel
@property (nonatomic,strong) NSArray *luckyOrderListArr;

+(LuckyOrderListModel*)shareLuckyOrderList;
-(void)loadLuckyOrderListWithStrat:(NSInteger)startItem withLength:(NSInteger)lenth;

@end
