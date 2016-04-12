//
//  VirtualForDateCell.h
//  RKWXT
//
//  Created by app on 16/4/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@interface VirtualForDateCell : WXUITableViewCell
- (void)allMonery;
- (void)allMoneryAddPostage;
+ (instancetype)VirtualForDateCellWithTabelView:(UITableView*)tableView;
@end
