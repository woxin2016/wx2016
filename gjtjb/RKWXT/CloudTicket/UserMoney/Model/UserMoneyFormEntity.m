//
//  UserMoneyFormEntity.m
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserMoneyFormEntity.h"

@implementation UserMoneyFormEntity

+(UserMoneyFormEntity*)initUserMoneyFormEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        CGFloat balance = [[dic objectForKey:@"balance"] floatValue];
        [self setBalance:balance];
        
        CGFloat complete = [[dic objectForKey:@"completed"] floatValue];
        [self setCompleteMoney:complete];
        
        CGFloat onGoing = [[dic objectForKey:@"ongoing"] floatValue];
        [self setOnGoingMoney:onGoing];
    }
    return self;
}

@end
