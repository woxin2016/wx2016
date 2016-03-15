//
//  ShopPingCartModel.h
//  RKWXT
//
//  Created by app on 16/3/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#warning mark  ---  此类重复 （勿用）
#import <Foundation/Foundation.h>

//typedef enum{
//    ShopPingCartModel_Structure_Add,
//    ShopPingCartModel_Structure_Remove,
//}ShopPingCartModel_Structure;

@interface ShopPingCartModel : NSObject
@property (nonatomic,strong)NSMutableArray *shoppingCartArray;
+ (instancetype)shopPingCartModelAlloc;
- (NSInteger)unreadShopNumber;

@end
