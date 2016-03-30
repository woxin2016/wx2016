//
//  SellerListEntity.h
//  RKWXT
//
//  Created by SHB on 16/3/29.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellerListEntity : NSObject
@property (nonatomic,strong) NSString *address;
@property (nonatomic,assign) NSInteger sellerID;
@property (nonatomic,strong) NSString *sellerName;
@property (nonatomic,strong) NSString *logoImg;
@property (nonatomic,assign) NSInteger shopID;
@property (nonatomic,strong) NSString *shopName;

+(SellerListEntity*)initSellerListEntityWithDic:(NSDictionary*)dic;

@end
