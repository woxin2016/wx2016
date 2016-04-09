//
//  UserMoneyInfoEntity.m
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserMoneyInfoEntity.h"

@implementation UserMoneyInfoEntity

+(UserMoneyInfoEntity*)initUserMoneyInfoEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *ct = [dic objectForKey:@"title"];
        [self setTitle:ct];
        
        NSInteger addtime = [[dic objectForKey:@"add_time"] integerValue];
        [self setAddTime:addtime];
        
        NSString *title = [dic objectForKey:@"number"];
        [self setMoneyInfo:title];
    }
    return self;
}

@end
