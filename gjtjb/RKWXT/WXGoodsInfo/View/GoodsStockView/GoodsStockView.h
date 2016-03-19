//
//  GoodsStockView.h
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#warning mark --- 加入购物车  弃用

#import "WXUIView.h"

#define K_Notification_Name_UserBuyGoods @"K_Notification_Name_UserBuyGoods"
#define K_Notification_Name_UserAddShoppingCart @"K_Notification_Name_UserAddShoppingCart"

typedef enum{
    GoodsStockView_Type_ShoppingCart = 0,
    GoodsStockView_Type_Buy,
}GoodsStockView_Type;

@interface GoodsStockView : WXUIView
@property (nonatomic,assign) GoodsStockView_Type goodsViewType;
@property (nonatomic,assign) NSInteger buyNum;
@property (nonatomic,assign) NSInteger stockID;
@property (nonatomic,strong) NSString *stockName;
@property (nonatomic,assign) CGFloat stockPrice;
@property (nonatomic,assign) NSInteger redPacket;
-(void)loadGoodsStockInfo:(NSArray*)stockArr;

@end
