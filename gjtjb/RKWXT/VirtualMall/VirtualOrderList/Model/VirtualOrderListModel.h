//
//  VirtualOrderListModel.h
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define V_Notification_Name_CancelVirtualOrderSuccend @"V_Notification_Name_CancelVirtualOrderSuccend"
#define V_Notification_Name_CancelVirtualOrderFailure @"V_Notification_Name_CancelVirtualOrderFailure"
#define V_Notification_Name_CancelVirtualConfirmOrderSuccend @"V_Notification_Name_CancelVirtualConfirmOrderSuccend"
#define V_Notification_Name_CancelVirtualConfirmOrderFailure @"V_Notification_Name_CancelVirtualConfirmOrderFailure"

@protocol VirtualOrderListModelDelegate <NSObject>
- (void)VirtualOrderListLoadSucceed;
- (void)virtualGoodsOrderListFailed:(NSString*)failure;

- (void)VirtualConfirmOrderSuccend;
- (void)VirtualConfirmOrderFailure:(NSString*)failure;
@end

@interface VirtualOrderListModel : NSObject
@property (nonatomic,strong)NSArray *listArray;
@property (nonatomic,weak)id<VirtualOrderListModelDelegate> delegate;
- (void)loadVirtualOrderListWithStart:(NSInteger)start lenght:(NSInteger)lenght;
- (void)cancelOrderIDWith:(NSInteger)orderID;
- (void)confirmOrderBtnWithOrderID:(NSInteger)orderID;
@end
