//
//  VirtualInfoDownCell.h
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@interface VirtualInfoDownCell : WXUITableViewCell
- (void)downWithName:(NSString*)name info:(NSString*)info;
+ (instancetype)VirtualInfoDownCellWithTabelView:(UITableView*)tableView;
@end
