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
    
    
    
        if (structrue == ShopPingCartModel_Structure_Add) {
    
            self.number++;
           
            WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
            [userDefault setInteger:self.number forKey:D_WXUserdefault_Key_ShoppingCartCount];
        }
        
        
        if (structrue == ShopPingCartModel_Structure_Remove) {
            
            self.number--;
            
            WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
            [userDefault setInteger:self.number  forKey:D_WXUserdefault_Key_ShoppingCartCount];
        }
        
    
    
}

- (NSString *)storagePath{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    return [paths lastObject];
}


@end
