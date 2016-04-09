//
//  UserMoneyInfoModel.h
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserMoneyInfoModelDelegate;

@interface UserMoneyInfoModel : NSObject
@property (nonatomic,weak) id<UserMoneyInfoModelDelegate>delegate;
@property (nonatomic,strong) NSArray *userMoneyInfoArr;

-(void)loadUserMoneyInfoData:(NSInteger)startItem length:(NSInteger)length days:(NSInteger)days;
@end

@protocol UserMoneyInfoModelDelegate <NSObject>
-(void)loadUserCloudTicketDataSucceed;
-(void)loadUserCloudTicketDataFailed:(NSString*)errorMsg;

@end