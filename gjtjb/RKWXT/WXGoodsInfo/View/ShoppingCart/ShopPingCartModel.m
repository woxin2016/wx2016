//
//  ShopPingCartModel.m
//  RKWXT
//
//  Created by app on 16/3/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//Œ

#import "ShopPingCartModel.h"

@implementation ShopPingCartModel

- (NSMutableArray*)shoppingCartArray{
    if (!_shoppingCartArray) {
        _shoppingCartArray = [NSMutableArray array];
    }
    return _shoppingCartArray;
}

+ (instancetype)shopPingCartModelAlloc{
    static ShopPingCartModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[ShopPingCartModel alloc]init];
    });
    return model;
}


- (NSInteger)unreadShopNumber{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault integerValueForKey:D_WXUserdefault_Key_ShoppingCartCount];
}

- (void)setUnreadGoodsID:(NSInteger)goodsID{

     if (goodsID) {

        NSString *str = [NSString stringWithFormat:@"%d",goodsID];
        [self.shoppingCartArray addObject:str];
        
        NSArray *array = [NSArray arrayWithArray:self.shoppingCartArray];
        
        for (NSString *goods in array) {   // 剔除掉重复的goodsID
             if ([goods isEqualToString:str]) {
                 [self.shoppingCartArray removeObject:goods];
             }
         }
         
         WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
         [userDefault setInteger:self.shoppingCartArray.count forKey:D_WXUserdefault_Key_ShoppingCartCount];
    }
 
    
}








@end
