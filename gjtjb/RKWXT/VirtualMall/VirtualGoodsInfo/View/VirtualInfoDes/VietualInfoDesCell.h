//
//  VietualInfoDesCell.h
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@interface VietualInfoDesCell : WXUITableViewCell
+ (instancetype)VietualInfoDesCellWithTabelView:(UITableView*)tableView;
- (void)backMoney:(CGFloat)money xnb:(int)xnb;
@end
