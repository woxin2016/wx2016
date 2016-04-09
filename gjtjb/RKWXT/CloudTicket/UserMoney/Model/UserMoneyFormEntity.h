//
//  UserMoneyFormEntity.h
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMoneyFormEntity : NSObject
@property (nonatomic,assign) CGFloat balance;
@property (nonatomic,assign) CGFloat completeMoney;
@property (nonatomic,assign) CGFloat onGoingMoney;

+(UserMoneyFormEntity*)initUserMoneyFormEntity:(NSDictionary*)dic;

@end
