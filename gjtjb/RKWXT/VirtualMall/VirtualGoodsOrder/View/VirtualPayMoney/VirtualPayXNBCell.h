//
//  VirtualPayXNBCell.h
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@interface VirtualPayXNBCell : WXUITableViewCell
- (void)userCanXNB:(CGFloat)XNB;
+ (instancetype)VirtualPayXNBCellWithTabelView:(UITableView*)tableView;
@end
