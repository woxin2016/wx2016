//
//  UserCloudTicketEntity.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserCloudTicketEntity.h"

@implementation UserCloudTicketEntity

+(UserCloudTicketEntity*)initUserCloudTicketEntityWith:(NSDictionary *)dic{
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
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@",title];
        if (str.length > 0) {
           [str insertString:@"￥" atIndex:1];
        }
        [self setCloudTicket:str];
    }
    return self;
}

@end
