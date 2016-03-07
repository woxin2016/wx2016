//
//  LuckyGoodsInfoModel.h
//  RKWXT
//
//  Created by SHB on 16/3/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"
@class LuckyGoodsEntity;

@protocol LuckyGoodsInfoModelDelegate;
@interface LuckyGoodsInfoModel : T_HPSubBaseModel
@property (nonatomic,assign) id<LuckyGoodsInfoModelDelegate>delegate;
@property (nonatomic,assign) NSInteger goodID;
@property (nonatomic,strong) LuckyGoodsEntity *entity;

-(void)loadGoodsInfo:(NSInteger)goods_id;  //普通商品
-(BOOL)shouldDataReload;

@end

@protocol LuckyGoodsInfoModelDelegate <NSObject>
-(void)goodsInfoModelLoadedSucceed;
-(void)goodsInfoModelLoadedFailed:(NSString*)errorMsg;

@end
