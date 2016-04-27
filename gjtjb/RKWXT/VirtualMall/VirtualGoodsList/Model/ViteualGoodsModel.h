//
//  ViteualGoodsModel.h
//  RKWXT
//
//  Created by app on 16/4/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ModelType_Store = 1,
    ModelType_Exchange
}ModelType;



@protocol viteualGoodsModelDelegate;
@interface ViteualGoodsModel : NSObject
@property (nonatomic,weak)id<viteualGoodsModelDelegate> delegate;
@property (nonatomic,strong)NSArray *storeArray;
@property (nonatomic,strong)NSArray *exchangeArray;
- (void)viteualGoodsModelRequeatNetWork:(ModelType)type start:(NSInteger)start length:(NSInteger)length;
- (void)virtualLoadDataFromWeb;

// 顶部大图
@property (nonatomic,strong) NSArray *downImgArr;
@end

@protocol viteualGoodsModelDelegate <NSObject>
-(void)viteualGoodsModelSucceed;
-(void)viteualGoodsModelFailed:(NSString*)errorMsg;
-(void)viteualTopImgSucceed;
-(void)viteualTopImgFailed:(NSString*)errorMsg;
- (void)vieualNoGoodsData;
@end
