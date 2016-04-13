//
//  MoreMoneyInfoModel.h
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

#define K_Notification_Name_LoadUserMoreMoneyInfoSucceed @"K_Notification_Name_LoadUserMoreMoneyInfoSucceed"  //获取用户云票，现金，话费余额等
#define K_Notification_Name_UserCloudTicketChanged @"K_Notification_Name_UserCloudTicketChanged"   //云票数量发生变化
#define K_Notification_Name_UserMoneyBalanceChanged @"K_Notification_Name_UserMoneyBalanceChanged"   //现金发生变化

@interface MoreMoneyInfoModel : T_HPSubBaseModel
@property (nonatomic,assign) NSInteger userCloudBalance;  //使用之前请判断是否已经加载成功
@property (nonatomic,assign) CGFloat userMoneyBalance;  //使用之前请判断是否已经加载成功

@property (nonatomic,assign) BOOL isLoaded;
@property (nonatomic,assign) BOOL isChanged;

+(MoreMoneyInfoModel*)shareUserMoreMoneyInfo;
-(void)loadUserMoreMoneyInfo;

@end
