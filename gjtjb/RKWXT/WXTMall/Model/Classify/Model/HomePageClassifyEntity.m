//
//  HomePageClassifyEntity.m
//  RKWXT
//
//  Created by SHB on 16/3/31.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomePageClassifyEntity.h"
#import <objc/runtime.h>

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
        unsigned int count;
        objc_property_t *property_t_array = class_copyPropertyList([HomePageClassifyEntity class], &count);
        for(int i = 0;i < count; i++){
            objc_property_t pro_t = property_t_array[i];
            const char *pro_name = property_getName(pro_t);
            NSString *key = [NSString stringWithUTF8String:pro_name];
            id value = [dic valueForKey:key];
            [self setValue:value forKey:key];
        }
        free(property_t_array);
    }
    return self;
}

@end
