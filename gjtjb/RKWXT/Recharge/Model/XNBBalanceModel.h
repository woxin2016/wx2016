//
//  XNBBalanceModel.h
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XNBBalanceModelDlegatge;
@class XNBOrderEntity;
@interface XNBBalanceModel : NSObject
@property (nonatomic,strong)XNBOrderEntity *order;
@property (nonatomic,strong)NSMutableArray *cartArray;;
@property (nonatomic,weak)id<XNBBalanceModelDlegatge> delegate;
- (void)requestLoadCartInfo;
- (void)balanceSubmitOrdersWithKey:(NSInteger)key phone:(NSString*)phone;
@end

@protocol XNBBalanceModelDlegatge <NSObject>
-(void)loadXNBUserBalanceSucceed;
-(void)loadXNBUserBalanceFailed:(NSString*)errorMsg;
- (void)balanceSubmitOrderSucceed;
-(void)balanceSubmitOrderFailed:(NSString*)errorMsg;
@end