//
//  VirtualGoodsInfoModel.h
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    VirtualModelRequestType_Default,
     VirtualModelRequestType_Store,
    VirtualModelRequestType_Exchange,
}VirtualModelRequestType;

@protocol VirtualGoodsInfoModelDelegate <NSObject>
-(void)virtualLoadGoodsInfoDataSucceed;
-(void)virtualLoadGoodsInfoDataFailed:(NSString*)errorMsg;
@end

@interface VirtualGoodsInfoModel : NSObject
@property (nonatomic,assign) id<VirtualGoodsInfoModelDelegate> delegate;
@property (nonatomic,strong) NSArray *goodsInfoArr; //商品详情
@property (nonatomic,strong) NSArray *attrArr;      //属性
@property (nonatomic,strong) NSArray *stockArr;     //库存
@property (nonatomic,strong) NSArray *sellerArr;     //所属商家
-(void)virtualLoadGoodsInfoData:(NSInteger)goodsID type:(VirtualModelRequestType)type;
@end

