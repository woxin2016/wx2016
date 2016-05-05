//
//  XNBBalanceEntity.h
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNBBalanceEntity : NSObject
@property (nonatomic,assign)int xnbBalnce;
@property (nonatomic,assign)int xnb;
@property (nonatomic,assign)int rmb;
@property (nonatomic,assign)int monery;
+ (instancetype)xnbBalanceEntityWithDict:(NSDictionary*)dict;
@end
