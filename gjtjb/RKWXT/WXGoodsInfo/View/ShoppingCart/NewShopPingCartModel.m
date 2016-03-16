//
//  NewShopPingCartModel.m
//  RKWXT
//
//  Created by app on 16/3/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "NewShopPingCartModel.h"

@interface NewShopPingCartModel ()
@property (nonatomic,assign)NSInteger number;
@end

@implementation NewShopPingCartModel
- (NSMutableArray*)shoppingCartArray{
    if (!_shoppingCartArray) {
        _shoppingCartArray = [NSMutableArray array];
    }
    return _shoppingCartArray;
}

+ (instancetype)shopPingCartModelAlloc{
    static NewShopPingCartModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[NewShopPingCartModel alloc]init];
    });
    return model;
}


- (NSInteger)unreadShopNumber{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault integerValueForKey:D_WXUserdefault_Key_ShoppingCartCount];
}


- (void)setUnreadGoodsID:(NSInteger)goodsID structrue:(ShopPingCartModel_Structure)structrue{
    if (!goodsID) return ;
    
       NSString *goods = [NSString stringWithFormat:@"%d",goodsID];
       self.shoppingCartArray  = [NSMutableArray arrayWithContentsOfFile:[self storagePath]];
       NSMutableArray *array = [NSMutableArray arrayWithArray:self.shoppingCartArray];
    
    
        if (structrue == ShopPingCartModel_Structure_Add) {  // 添加购物车商品
            [array addObject:goods];
            self.shoppingCartArray = [array valueForKeyPath:@"@distinctUnionOfObjects.self"];
        }
        
        
        if (structrue == ShopPingCartModel_Structure_Remove) { // 删除购物车商品
            for (NSString *str in array) {
                if ([str isEqualToString:goods]) {
                    [self.shoppingCartArray removeObject:str];
                }
            }
            
        }
    
    [self.shoppingCartArray writeToFile:[self storagePath] atomically:YES];
    
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setInteger:self.shoppingCartArray.count  forKey:D_WXUserdefault_Key_ShoppingCartCount];
    
}

- (NSString *)storagePath{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *doc = [paths lastObject];
    NSString *store = [doc stringByAppendingPathComponent:@"shoppingCart.text"];
    return store;
}


@end
