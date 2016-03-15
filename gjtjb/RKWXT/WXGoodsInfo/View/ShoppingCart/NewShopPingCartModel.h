//
//  NewShopPingCartModel.h
//  RKWXT
//
//  Created by app on 16/3/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ShopPingCartModel_Structure_Add,
    ShopPingCartModel_Structure_Remove,
}ShopPingCartModel_Structure;

@interface NewShopPingCartModel : NSObject
@property (nonatomic,strong)NSMutableArray *shoppingCartArray;
+ (instancetype)shopPingCartModelAlloc;
- (NSInteger)unreadShopNumber;  //购物车商品数量
- (void)setUnreadGoodsID:(NSInteger)goodsID structrue:(ShopPingCartModel_Structure)structrue; //添加和删除商品数量
@end
