//
//  SignEntity.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "SignEntity.h"

@implementation SignEntity

+(SignEntity*)signWithDictionary:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    if(self = [super init]){
        CGFloat money = [[dic objectForKey:@"number"] floatValue];
        [self setMoney:money];
        
        NSInteger type = [[dic objectForKey:@"type"] integerValue];
        [self setType:type];
    }
    return self;
}

@end
