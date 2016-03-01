//
//  OrderEvaluteVC.h
//  RKWXT
//
//  Created by SHB on 16/3/1.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#define K_Notification_Name_UserEvaluateOrderSucceed @"K_Notification_Name_UserEvaluateOrderSucceed"

@class AllOrderListEntity;

@interface OrderEvaluteVC : WXUIViewController
@property (nonatomic,strong) AllOrderListEntity *orderEntity;

@end
