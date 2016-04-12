//
//  HomePageTopEntity.m
//  RKWXT
//
//  Created by SHB on 16/1/15.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomePageTopEntity.h"

@implementation HomePageTopEntity

+(HomePageTopEntity*)homePageTopEntityWithDictionary:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithJsonDictionary:dic];
}

-(id)initWithJsonDictionary:(NSDictionary*)dic{
    if(self = [super init]){
        NSString *topImg = [dic objectForKey:@"top_image"];
        [self setTopImg:topImg];
        
        NSInteger link = [[dic objectForKey:@"top_address_id"] integerValue];
        [self setLinkID:link];
        
        NSInteger type = [[dic objectForKey:@"top_nav_type_id"] integerValue];
        [self setTopAddID:type];
        
        NSInteger sort_order = [[dic objectForKey:@"top_id"] integerValue];
        [self setSortID:sort_order];
        
        NSInteger position = [[dic objectForKey:@"show_position" ] integerValue];
        [self setPosition:position];
        
        NSString *url_address = [dic objectForKey:@"url_address"];
        [self setUrl_address:url_address];
    }
    return self;
}

@end
