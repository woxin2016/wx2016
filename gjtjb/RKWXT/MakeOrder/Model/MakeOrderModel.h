//
//  MakeOrderModel.h
//  RKWXT
//
//  Created by SHB on 15/6/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol MakeOrderDelegate;

@interface MakeOrderModel : T_HPSubBaseModel
@property (nonatomic,assign) id<MakeOrderDelegate>delegate;
@property (nonatomic,strong) NSString *orderID;

-(void)submitOrderDataWithTotalMoney:(CGFloat)totalMoney factPay:(CGFloat)fectPay redPac:(CGFloat)redPacket carriage:(CGFloat)carriage remark:(NSString*)remark goodsInfo:(NSString*)goodsInfo;
-(void)limitSubmitOrderDataWithTotalMoney:(CGFloat)totalMoney factPay:(CGFloat)fectPay redPac:(CGFloat)redPacket carriage:(CGFloat)carriage remark:(NSString*)remark goodsInfo:(NSString*)goodsInfo inventory:(NSString*)inventory goodsID:(NSString*)goodsID;
@end

@protocol MakeOrderDelegate <NSObject>
-(void)makeOrderSucceed;
-(void)makeOrderFailed:(NSString*)errorMsg;

@end
