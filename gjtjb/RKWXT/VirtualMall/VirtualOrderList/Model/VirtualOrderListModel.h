//
//  VirtualOrderListModel.h
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VirtualOrderListModelDelegate <NSObject>
- (void)VirtualOrderListLoadSucceed;
- (void)virtualGoodsOrderListFailed:(NSString*)failure;
@end

@interface VirtualOrderListModel : NSObject
@property (nonatomic,strong)NSArray *listArray;
@property (nonatomic,weak)id<VirtualOrderListModelDelegate> delegate;
- (void)loadVirtualOrderListWithStart:(NSInteger)start lenght:(NSInteger)lenght;
@end
