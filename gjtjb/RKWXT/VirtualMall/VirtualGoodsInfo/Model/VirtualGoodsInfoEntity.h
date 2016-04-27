//
//  VirtualGoodsInfoEntity.h
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface VirtualGoodsInfoEntity : NSObject
@property (nonatomic,strong) NSString *homeImg;
@property (nonatomic,strong) NSString *goodsImg;
@property (nonatomic,strong) NSArray *goodsImgArr;
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,assign) CGFloat marketPrice;
@property (nonatomic,assign) NSInteger meterageID;
@property (nonatomic,strong) NSString *meterageName;
@property (nonatomic,assign) NSInteger goodshop_id;
@property (nonatomic,strong) NSString *goodsShopName;
@property (nonatomic,assign) int  pastVirtual;  //已经兑换的虚拟币
@property (nonatomic,assign) CGFloat postageVirtual;  //邮费
@property (nonatomic,strong) NSString *virtualImg;

// 商家信息
@property (nonatomic,strong) NSString *sellerAddress;
@property (nonatomic,assign) CGFloat sellerLatitude;
@property (nonatomic,assign) CGFloat sellerLongitude;
@property (nonatomic,assign) NSInteger sellerID;
@property (nonatomic,strong) NSString *sellerName;
@property (nonatomic,strong) NSString *sellerPhone;

//基本参数
@property (nonatomic,strong) NSString *attrName;
@property (nonatomic,strong) NSString *attrValue;
@property (nonatomic,strong)NSArray *atterNameArr;
@property (nonatomic,strong)NSArray *atterValueArr;

//评价
@property (nonatomic,assign) NSInteger addTime;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *userPhone;
@property (nonatomic,strong) NSString *userHeadImg;

//相关店铺
@property (nonatomic,strong) NSString *shopAddress;
@property (nonatomic,assign) CGFloat shopLatitude;
@property (nonatomic,assign) CGFloat shopLongitude;
@property (nonatomic,assign) CGFloat shopDistance;
@property (nonatomic,assign) CGFloat shopID;
@property (nonatomic,strong) NSString *shopName;

//库存
@property (nonatomic,assign) NSInteger userCut;
@property (nonatomic,assign) NSInteger stockNum;
@property (nonatomic,assign) CGFloat stockPrice;
@property (nonatomic,assign) NSInteger stockID;
@property (nonatomic,strong) NSString *stockName;
@property (nonatomic,assign) NSInteger redPacket;
@property (nonatomic,assign) int canVirtual;  // 可以兑换的虚拟币
@property (nonatomic,assign) BOOL isDefault;    //是否默认显示
@property (nonatomic,assign) CGFloat backMoney; //返现金额
@property (nonatomic,assign) int xnb;  //商品需要的虚拟币
@property (nonatomic,assign) CGFloat goodsPrice;  //  商品价格


//临时属性
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) NSInteger buyNumber;

+(VirtualGoodsInfoEntity *)initGoodsInfoEntity:(NSDictionary*)dic;  //商品详情
+(VirtualGoodsInfoEntity *)initSellerInfoEntity:(NSDictionary*)dic;  //所属商家
+(VirtualGoodsInfoEntity *)initBaseAttrDataEntity:(NSDictionary*)dic;//基础属性
+(VirtualGoodsInfoEntity *)initEvaluteDataEntity:(NSDictionary*)dic;  //评价
+(VirtualGoodsInfoEntity *)initOtherShopEntity:(NSDictionary*)dic;  //推荐商家
+(VirtualGoodsInfoEntity *)initStockDataEntity:(NSDictionary*)dic; //库存


@end
