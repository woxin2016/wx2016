//
//  collectionView.h
//  RKWXT
//
//  Created by app on 16/3/23.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectionGoodsEntity;
@protocol collectionViewDelegate;
@interface collectionView : UIView
@property (nonatomic,weak)id<collectionViewDelegate> delegate;
@property (nonatomic,strong)CollectionGoodsEntity *entity;
@end

@protocol collectionViewDelegate <NSObject>
- (void)colltionViewClickGoods:(NSInteger)goodsID;
- (void)colltionViewClickDeleteGoods:(NSInteger)goodsID;
@end