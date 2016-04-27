//
//  VirtualInfoDesExchangeCell.h
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@interface VirtualInfoDesExchangeCell : WXUITableViewCell
+ (instancetype)VirtualInfoDesExchangeCellWithTabelView:(UITableView*)tableView;
- (void)backMoney:(CGFloat)money xnb:(int)xnb goodsPrice:(CGFloat)goodsPrice;
@end
