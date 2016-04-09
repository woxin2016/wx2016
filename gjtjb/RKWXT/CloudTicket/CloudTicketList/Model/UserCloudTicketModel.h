//
//  UserCloudTicketModel.h
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserCloudTicketModelDelegate;

@interface UserCloudTicketModel : NSObject
@property (nonatomic,weak) id<UserCloudTicketModelDelegate>delegate;
@property (nonatomic,strong) NSArray *userCloudArr;

-(void)loadUserCloudTicketData:(NSInteger)startItem length:(NSInteger)length days:(NSInteger)days;
@end

@protocol UserCloudTicketModelDelegate <NSObject>
-(void)loadUserCloudTicketDataSucceed;
-(void)loadUserCloudTicketDataFailed:(NSString*)errorMsg;

@end
