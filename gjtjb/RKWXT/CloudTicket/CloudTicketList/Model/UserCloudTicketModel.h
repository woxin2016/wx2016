//
//  UserCloudTicketModel.h
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define K_Notification_Name_LoadUserCloudTicketSucceed @"K_Notification_Name_LoadUserCloudTicketSucceed"
#define K_Notification_Name_LoadUserCloudTicketFailed  @"K_Notification_Name_LoadUserCloudTicketFailed"

@interface UserCloudTicketModel : NSObject
@property (nonatomic,strong) NSArray *weekCTListArr;
@property (nonatomic,strong) NSArray *monthCTListArr;
@property (nonatomic,strong) NSArray *allCTListArr;

+(UserCloudTicketModel*)sharedUserCloudTicket;
-(void)loadUserCloudTicketData;

@end
