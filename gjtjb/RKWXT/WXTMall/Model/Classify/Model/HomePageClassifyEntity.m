//
//  HomePageClassifyEntity.m
//  RKWXT
//
//  Created by SHB on 16/3/31.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomePageClassifyEntity.h"

@implementation HomePageClassifyEntity

+(HomePageClassifyEntity*)initClassifyEntityWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger cat_id = [[dic objectForKey:@"cat_id"] integerValue];
        [self setCatID:cat_id];
        
        NSString *catImg = [dic objectForKey:@"cat_img"];
        [self setCatImg:catImg];
        
        NSString *catName = [dic objectForKey:@"cat_name"];
        [self setCatName:catName];
        
        NSInteger flag = [[dic objectForKey:@"flag"] integerValue];
        [self setFlag:flag];
    }
    return self;
}

@end
