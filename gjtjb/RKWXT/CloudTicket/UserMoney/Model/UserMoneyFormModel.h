//
//  UserMoneyFormModel.h
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户提现金额，提现中，已提现

@protocol UserMoneyFormModelDelegate;

@interface UserMoneyFormModel : NSObject
@property (nonatomic,weak) id<UserMoneyFormModelDelegate>delegate;
@property (nonatomic,strong) NSArray *moneyFormArr;

-(void)loadUserMoneyFormData;
@end

@protocol UserMoneyFormModelDelegate <NSObject>
-(void)loadUserMoneyFormDataSucceed;
-(void)loadUserMoneyFormDataFailed:(NSString*)errorMsg;

@end
