//
//  HomeLimitGoodsModel.h
//  RKWXT
//
//  Created by app on 16/3/10.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol HomeLimitGoodsDelegate;
@interface HomeLimitGoodsModel : T_HPSubBaseModel
@property (nonatomic,assign) id<HomeLimitGoodsDelegate> delegate;
@end

@protocol HomeLimitGoodsDelegate <NSObject>
-(void)homePageLimitGoodsSucceed;
-(void)homePageLimitGoodsFailed:(NSString*)errorMsg;
- (void)limitBuyNoStartBuyGoods;
@end