//
//  GoodsBuyNumberCell.h
//  RKWXT
//
//  Created by app on 16/3/19.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol GoodsBuyNumberCellDelegate <NSObject>
- (void)goodsBuyRemoveNumber;
- (void)goodsBuyAddNumber;
@end

@interface GoodsBuyNumberCell : WXUITableViewCell
@property (nonatomic,weak)id<GoodsBuyNumberCellDelegate> delegate;
+ (instancetype)GoodsBuyNumberCellWithTableView:(UITableView*)tableView;
- (void)lookGoodsStockNumber:(NSUInteger)number;
@end
