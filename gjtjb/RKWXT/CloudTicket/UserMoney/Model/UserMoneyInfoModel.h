//
//  UserMoneyInfoModel.h
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    UserMoneyInfo_Type_Week = 0,
    UserMoneyInfo_Type_Month,
    UserMoneyInfo_Type_All,
}UserMoneyInfo_Type;

@protocol UserMoneyInfoModelDelegate;

@interface UserMoneyInfoModel : NSObject
@property (nonatomic,weak) id<UserMoneyInfoModelDelegate>delegate;
@property (nonatomic,strong) NSArray *userMoneyInfoArr;

-(void)loadUserMoneyInfoData:(NSInteger)startItem length:(NSInteger)length type:(UserMoneyInfo_Type)type;
@end

@protocol UserMoneyInfoModelDelegate <NSObject>
-(void)loadUserCloudTicketDataSucceed;
-(void)loadUserCloudTicketDataFailed:(NSString*)errorMsg;

@end