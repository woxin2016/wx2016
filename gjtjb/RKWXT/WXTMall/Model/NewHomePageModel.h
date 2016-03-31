//
//  NewHomePageModel.h
//  RKWXT
//
//  Created by SHB on 16/1/15.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageTop.h"
#import "HomePageRecModel.h"
#import "HomePageSurpModel.h"
#import "HomeLimitGoodsModel.h"
#import "HomePageClassifyModel.h"

@interface NewHomePageModel : NSObject
@property (nonatomic,assign) id<HomePageTopDelegate,HomePageRecDelegate,HomeLimitGoodsDelegate,HomePageClassifyModelDelegate>delegate;

@property (nonatomic,readonly) HomePageTop *top;
@property (nonatomic,readonly) HomePageRecModel *recommend;
@property (nonatomic,readonly) HomePageSurpModel *surprise;
@property (nonatomic,readonly) HomePageClassifyModel *classify;
@property (nonatomic,readonly) HomeLimitGoodsModel *limitGoods;

-(BOOL)isSomeDataNeedReload;
-(void)loadData;
-(void)toInit;

@end
