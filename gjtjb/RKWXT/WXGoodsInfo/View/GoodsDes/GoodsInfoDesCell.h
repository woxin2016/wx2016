//
//  GoodsInfoDesCell.h
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

//#define GoodsInfoDesCellHeight (73)
#define GoodsInfoDesCellHeight (93)
@class GoodsInfoEntity;

@protocol GoodsInfoDesCellDelegate;
@interface GoodsInfoDesCell : WXUITableViewCell
@property (nonatomic,assign) id<GoodsInfoDesCellDelegate>delegate;
@property (nonatomic,assign) BOOL userCut;
@property (nonatomic,assign) BOOL pocket;
@property (nonatomic,strong)GoodsInfoEntity *stockEntity;
- (void)setLikeGoodsisAttection:(BOOL)attection;
- (void)limitGoodsInfoHidden;
@end

@protocol GoodsInfoDesCellDelegate <NSObject>
-(void)goodsInfoDesCutBtnClicked;
-(void)goodsInfoDesCarriageBtnClicked;
- (void)goodsInfoDesredPacketBtnClicked;
- (void)goodsInfoDesAddlikeGoods:(BOOL)isAttection;
@end
