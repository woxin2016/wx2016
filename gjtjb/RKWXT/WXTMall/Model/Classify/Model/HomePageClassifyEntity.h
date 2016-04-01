//
//  HomePageClassifyEntity.h
//  RKWXT
//
//  Created by SHB on 16/3/31.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageClassifyEntity : NSObject
@property (nonatomic,assign) NSInteger catID;
@property (nonatomic,strong) NSString *catImg;
@property (nonatomic,strong) NSString *catName;
@property (nonatomic,assign) NSInteger flag;

+(HomePageClassifyEntity*)initClassifyEntityWithDic:(NSDictionary*)dic;

@end
