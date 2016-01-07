//
//  BalanceModel.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoadUserBalanceDelegate;
@interface BalanceModel : NSObject
@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,assign) id<LoadUserBalanceDelegate>delegate;

-(void)loadUserBalance;
@end

@protocol LoadUserBalanceDelegate <NSObject>
-(void)loadUserBalanceSucceed;
-(void)loadUserBalanceFailed:(NSString*)errorMsg;

@end
