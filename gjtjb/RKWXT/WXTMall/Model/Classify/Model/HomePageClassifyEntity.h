//
//  HomePageClassifyEntity.h
//  RKWXT
//
//  Created by SHB on 16/3/31.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageClassifyEntity : NSObject
@property (nonatomic,assign) NSInteger cat_id;
@property (nonatomic,strong) NSString *cat_img;
@property (nonatomic,strong) NSString *cat_name;
@property (nonatomic,assign) NSInteger flag;

+(HomePageClassifyEntity*)initClassifyEntityWithDic:(NSDictionary*)dic;

@end
