//
//  VirtualInfoIntegralCell.h
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@interface VirtualInfoIntegralCell : WXUITableViewCell
+ (instancetype)VirtualInfoIntegralCellWithTabelView:(UITableView*)tableView;
- (void)canuseInterral:(NSString*)canUse cantBe:(NSString*)cantBe;
@end
