//
//  UserCloudTicketEntity.h
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCloudTicketEntity : NSObject
@property (nonatomic,strong) NSString *cloudTicket;
@property (nonatomic,assign) NSInteger addTime;
@property (nonatomic,strong) NSString *title;

+(UserCloudTicketEntity*)initUserCloudTicketEntityWith:(NSDictionary*)dic;

@end
