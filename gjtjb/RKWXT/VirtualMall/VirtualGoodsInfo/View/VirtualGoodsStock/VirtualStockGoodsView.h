//
//  VirtualStockGoodsView.h
//  RKWXT
//
//  Created by app on 16/4/9.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#define K_Notification_Name_VirtualStoreBuyGoods  @"K_Notification_Name_VirtualStoreBuyGoods"
#define K_Notification_Name_VirtualEXchangeBuyGoods  @"K_Notification_Name_VirtualEXchangeBuyGoods"

typedef enum{
    VirtualStockView_Type_Default = 0,
    VirtualStockView_Type_BuyStore,
    VirtualOrderInfoEntity_BuyEXchange,
}VirtualGoodsStockView_Type;

enum{
    VirtualGoodsInfoSection_Entity,
    VirtualGoodsInfoSectionStock_Number,
//    VirtualGoodsInfoSectionBuy_Number,
    VirtualGoodsInfoSection_Invalid
};

@class VirtualOrderInfoEntity;
@interface VirtualStockGoodsView : UIView
@property (nonatomic,assign)VirtualGoodsStockView_Type type;
@property (nonatomic,strong)VirtualOrderInfoEntity *virtualOrder;
- (void)VirtualGoodsStockInfo:(NSArray *)stockArr GoodsInfoArr:(NSArray *)goodsInfoArr;
@end
