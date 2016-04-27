//
//  GoodsInfoStockCell.h
//  RKWXT
//
//  Created by app on 16/3/18.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@interface GoodsInfoStockCell : WXUITableViewCell
@property (nonatomic,strong)NSString *imgUrl;
+ (instancetype)GoodsInfoStockCellWithTableView:(UITableView*)tableView;
- (void)setPrice;
- (void)setPriceAddXnb;
@end
