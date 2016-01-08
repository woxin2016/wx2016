//
//  FindEntity.m
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "FindEntity.h"

@implementation FindEntity

+(FindEntity*)initFindEntityWith:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *url = [dic objectForKey:@"url"];
        [self setWebUrl:url];
        
        NSString *iconURL = [dic objectForKey:@"icon_url"];
        [self setIcon_url:iconURL];
        
        NSString *name = [dic objectForKey:@"name"];
        [self setName:name];
    }
    return self;
}

@end
