//
//  LuckyGoodsOrderInfoModel.h
//  RKWXT
//
//  Created by SHB on 16/3/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LuckyGoodsOrderInfoModelDelegate;

@interface LuckyGoodsOrderInfoModel : NSObject
@property (nonatomic,assign) id<LuckyGoodsOrderInfoModelDelegate>delegate;

-(void)completeLuckyOrderWith:(NSInteger)orderID;
@end

@protocol LuckyGoodsOrderInfoModelDelegate <NSObject>
-(void)completeLuckyOrderSucceed;
-(void)completeLuckyOrderFailed:(NSString*)errorMsg;

@end
