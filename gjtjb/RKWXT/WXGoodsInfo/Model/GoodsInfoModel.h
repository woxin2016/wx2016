//
//  GoodsInfoModel.h
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoodsInfoModelDelegate;

typedef enum{
    GoodsInfoModel_Request_Type_Normal = 0,
    GoodsInfoModel_Request_Type_LuckyGoods,
    GoodsInfoModel_Request_Type_LimitGoods
}GoodsInfoModel_Request_Type;

@interface GoodsInfoModel : NSObject
@property (nonatomic,assign) id<GoodsInfoModelDelegate>delegate;
@property (nonatomic,strong) NSArray *goodsInfoArr; //商品详情
@property (nonatomic,strong) NSArray *evaluteArr;   //评价
@property (nonatomic,strong) NSArray *attrArr;      //属性
@property (nonatomic,strong) NSArray *stockArr;     //库存
@property (nonatomic,strong) NSArray *sellerArr;     //所属商家
@property (nonatomic,strong) NSArray *otherShopArr;  //推荐店铺

-(void)loadGoodsInfoData:(NSInteger)goodsID;
-(void)loadGoodsInfoData:(NSInteger)goodsID  seckillID:(NSInteger)seckillID type:(NSInteger)type;
@end

@protocol GoodsInfoModelDelegate <NSObject>
-(void)loadGoodsInfoDataSucceed;
-(void)loadGoodsInfoDataFailed:(NSString*)errorMsg;
@end
