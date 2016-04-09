//
//  UserMoneyInfoEntity.h
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMoneyInfoEntity : NSObject
@property (nonatomic,strong) NSString *moneyInfo;
@property (nonatomic,assign) NSInteger addTime;
@property (nonatomic,strong) NSString *title;

+(UserMoneyInfoEntity*)initUserMoneyInfoEntity:(NSDictionary*)dic;

@end
