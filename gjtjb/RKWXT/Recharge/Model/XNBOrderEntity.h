//
//  XNBOrderEntity.h
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNBOrderEntity : NSObject
@property (nonatomic,strong)NSString *orderID;
@property (nonatomic,assign)CGFloat price;
@property (nonatomic,assign)CGFloat xnb;
+ (instancetype)xnbOrderEntityWithDic:(NSDictionary*)dic;
@end
