//
//  UserCloudTicketModel.h
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    UserCloudTicket_Type_Week = 0,
    UserCloudTicket_Type_Month,
    UserCloudTicket_Type_All,
}UserCloudTicket_Type;

@protocol UserCloudTicketModelDelegate;

@interface UserCloudTicketModel : NSObject
@property (nonatomic,weak) id<UserCloudTicketModelDelegate>delegate;
@property (nonatomic,strong) NSArray *userCloudArr;

-(void)loadUserCloudTicketData:(NSInteger)startItem length:(NSInteger)length type:(UserCloudTicket_Type)type;
@end

@protocol UserCloudTicketModelDelegate <NSObject>
-(void)loadUserCloudTicketDataSucceed;
-(void)loadUserCloudTicketDataFailed:(NSString*)errorMsg;

@end
