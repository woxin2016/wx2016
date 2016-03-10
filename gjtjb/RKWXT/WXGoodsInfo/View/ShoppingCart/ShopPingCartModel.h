//
//  ShopPingCartModel.h
//  RKWXT
//
//  Created by app on 16/3/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ShopPingCartModel_Structure_Add,
    ShopPingCartModel_Structure_Remove,
}ShopPingCartModel_Structure;

@interface ShopPingCartModel : NSObject
@property (nonatomic,strong)NSMutableArray *shoppingCartArray;
+ (instancetype)shopPingCartModelAlloc;
- (NSInteger)unreadShopNumber;
- (void)setUnreadGoodsID:(NSInteger)goodsID structrue:(ShopPingCartModel_Structure)structrue;

@end
