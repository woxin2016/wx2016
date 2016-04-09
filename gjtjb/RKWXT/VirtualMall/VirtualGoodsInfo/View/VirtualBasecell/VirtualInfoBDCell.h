//
//  VirtualInfoBDCell.h
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@interface VirtualInfoBDCell : WXUITableViewCell
-(void)changeArrowWithDown:(BOOL)down;
+ (instancetype)VirtualInfoBDCellWithTabelView:(UITableView*)tableView;
@end
