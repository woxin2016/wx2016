//
//  VirtualStockGoodsView.h
//  RKWXT
//
//  Created by app on 16/4/9.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    VirtualStockView_Type_ShoppingCart = 0,
    VirtualStockView_Type_Buy,
}VirtualGoodsStockView_Type;

@interface VirtualStockGoodsView : UIView
@property (nonatomic,assign)VirtualGoodsStockView_Type type;
@property (nonatomic,assign) NSInteger buyNum;
@property (nonatomic,assign) NSInteger stockID;
@property (nonatomic,strong) NSString *stockName;
@property (nonatomic,assign) CGFloat stockPrice;
@property (nonatomic,assign) CGFloat postage;
@property (nonatomic,assign) CGFloat xnbPrice;
@property (nonatomic,assign) CGFloat backMoney;
@property (nonatomic,strong) NSString *goodsImg;
- (void)VirtualGoodsStockInfo:(NSArray *)stockArr GoodsInfoArr:(NSArray *)goodsInfoArr;
@end
