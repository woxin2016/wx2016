//
//  ShoppingCartEntity.h
//  RKWXT
//
//  Created by SHB on 16/1/19.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartEntity : NSObject
@property (nonatomic,assign) NSInteger cart_id; //购物车主键ID
@property (nonatomic,assign) NSInteger shop_id;//店铺ID
@property (nonatomic,assign) NSInteger goods_id; //商品ID
@property (nonatomic,strong) NSString *goods_name; //商品名称
@property (nonatomic,strong) NSString *smallImg;  //商品小图
@property (nonatomic,assign) CGFloat goods_price; //商品价格
@property (nonatomic,assign) NSInteger goods_Number;  //商品数量
@property (nonatomic,assign) NSInteger stockID;     //属性组合主键ID
@property (nonatomic,strong) NSString *stockName;   //属性组合名字
@property (nonatomic,assign) CGFloat bonusValue; //当前商品可以使用红包金额
@property (nonatomic,assign) NSInteger stock_number; //库存

@property (nonatomic,assign) BOOL selected;

+(ShoppingCartEntity*)initShoppingCartDataWithDictionary:(NSDictionary*)dic;

@end
