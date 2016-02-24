//
//  BalanceEntity.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BalanceEntity.h"

@implementation BalanceEntity

+(BalanceEntity*)initUserBalanceWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    if(self = [super init]){
        NSString *date = [dic objectForKey:@"combo"];
        [self setDate:date];
        
        CGFloat balance = [[dic objectForKey:@"telephone_fare"] floatValue];
        [self setMoney:balance];
        
        NSInteger state = [[dic objectForKey:@"is_combo"] integerValue];
        [self setType:state];
        
        NSInteger normalDate = [[dic objectForKey:@"fexpiry"] integerValue];
        [self setNormalDate:normalDate];
    }
    return self;
}

@end
