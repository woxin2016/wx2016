//
//  CollectionGoodsEntity.h
//  RKWXT
//
//  Created by app on 16/3/23.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionGoodsEntity : NSObject
@property (nonatomic,strong) NSString *homeImg;
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,assign) CGFloat marketPrice;
@property (nonatomic,assign) CGFloat shopPrice;
@property (nonatomic,assign) NSInteger deleGoodsID;
+ (instancetype)collectionGoodsEntity:(NSDictionary*)dic;
@end
