//
//  GoodsStockStyleCell.h
//  RKWXT
//
//  Created by app on 16/3/18.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol GoodsStockStyleCellDelegate <NSObject>
- (void)GoodsStockStyleSelectedGoodsName:(NSString*)goodsName;
@end

@interface GoodsStockStyleCell : WXUITableViewCell
@property (nonatomic,weak)id<GoodsStockStyleCellDelegate> delegate;
+ (instancetype)GoodsStockStyleCellWithTableView:(UITableView*)tableView;
- (void)setLabelHid:(BOOL)hid;
@end
