//
//  GoodsStockStyleCell.h
//  RKWXT
//
//  Created by app on 16/3/18.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"



@interface GoodsStockStyleCell : WXUITableViewCell
+ (instancetype)GoodsStockStyleCellWithTableView:(UITableView*)tableView;
- (void)setLabelHid:(BOOL)hid;
- (void)setLabelBackGroundColor:(BOOL)hid;
@end
