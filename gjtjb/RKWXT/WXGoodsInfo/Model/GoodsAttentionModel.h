//
//  GoodsAttentionModel.h
//  RKWXT
//
//  Created by app on 16/3/22.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>


#define K_Notification_Name_SearchGoodsAttentionSucceed @"K_Notification_Name_SearchGoodsAttentionSucceed"



#define K_Notification_Name_GoodsAttentionModelSucceed  @"K_Notification_Name_GoodsAttentionModelSucceed"
#define K_Notification_Name_GoodsAttentionModelFailed   @"K_Notification_Name_GoodsAttentionModelFailed"
#define K_Notification_Name_GoodsAttentionModelDeleteSucceed   @"K_Notification_Name_GoodsAttentionModelDeleteSucceed"
#define K_Notification_Name_GoodsAttentionModelIsAttention    @"K_Notification_Name_GoodsAttentionModelIsAttention"
#define K_Notification_Name_GoodsAttentionModelAddGoods    @"K_Notification_Name_GoodsPayAttentionSucceed"
typedef enum{
    GoodsAttentionModel_Type_addGoods = 1,
    GoodsAttentionModel_Type_goodsList,
    GoodsAttentionModel_Type_removeGoods,
    GoodsAttentionModel_Type_isQueryGoods,
}GoodsAttentionModel_Type;

typedef enum{
    GoodsAttentionModel_likeType_Goods = 1,
    GoodsAttentionModel_likeType_Store,
}GoodsAttentionModel_likeType;

@interface GoodsAttentionModel : NSObject
@property (nonatomic,strong)NSMutableArray *goodsArr;
+ (instancetype)goodsAttentionModelAlloc;
//收藏商品
-(void)searchGoodsPayAttention:(NSInteger)goodsID shopID:(NSInteger)shopID requestType:(GoodsAttentionModel_Type)type likeType:(GoodsAttentionModel_likeType)likeType;
//删除商品
-(void)deleteGoodsID:(NSInteger)deleteID requestType:(GoodsAttentionModel_Type)type likeType:(GoodsAttentionModel_likeType)likeType;
@end
