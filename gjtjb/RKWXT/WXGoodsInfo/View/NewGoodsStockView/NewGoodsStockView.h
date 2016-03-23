//
//  NewGoodsStockView.h
//  RKWXT
//
//  Created by app on 16/3/18.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUIView.h"

#define K_Notification_Name_UserBuyGoods @"K_Notification_Name_UserBuyGoods"
#define K_Notification_Name_UserAddShoppingCart @"K_Notification_Name_UserAddShoppingCart"

typedef enum{
    NewGoodsStockView_Type_ShoppingCart = 0,
    NewGoodsStockView_Type_Buy,
}NewGoodsStockView_Type;

enum{
    GoodsInfoSection_Entity,
    GoodsInfoSectionStock_Number,
    GoodsInfoSectionBuy_Number,
    GoodsInfoSection_Invalid
};

@interface NewGoodsStockView : UIView
@property (nonatomic,assign) NewGoodsStockView_Type goodsViewType;
@property (nonatomic,assign) NSInteger buyNum;
@property (nonatomic,assign) NSInteger stockID;
@property (nonatomic,strong) NSString *stockName;
@property (nonatomic,assign) CGFloat stockPrice;
@property (nonatomic,assign) NSInteger redPacket;
-(void)loadGoodsStockInfo:(NSArray*)stockArr GoodsInfoArr:(NSArray*)goodsInfoArr;
@end
