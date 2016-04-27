//
//  VirtualPayMoneryCell.h
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@interface VirtualPayMoneryCell : WXUITableViewCell
+ (instancetype)VirtualPayMoneryCellWithTabelView:(UITableView*)tableView;
- (void)userCanMonery:(CGFloat)monery;
@end
