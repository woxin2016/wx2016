//
//  VirtualAllMoneyCell.h
//  RKWXT
//
//  Created by app on 16/4/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@interface VirtualAllMoneyCell : WXUITableViewCell
- (void)hidePrice;
- (void)hidePriceAddPostage;
+ (instancetype)VirtualAllMoneyCellWithTabelView:(UITableView*)tableView;
@end
