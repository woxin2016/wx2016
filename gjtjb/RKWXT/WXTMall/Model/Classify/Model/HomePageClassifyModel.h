//
//  HomePageClassifyModel.h
//  RKWXT
//
//  Created by SHB on 16/3/31.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol HomePageClassifyModelDelegate;
@interface HomePageClassifyModel : T_HPSubBaseModel
@property (nonatomic,weak) id<HomePageClassifyModelDelegate>delegate;
@end

@protocol HomePageClassifyModelDelegate <NSObject>
-(void)homePageClassifyLoadedSucceed;
-(void)homePageClassifyLoadedFailed:(NSString*)errorMsg;

@end
