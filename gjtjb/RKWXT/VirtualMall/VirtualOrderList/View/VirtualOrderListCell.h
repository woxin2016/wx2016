//
//  VirtualOrderListCell.h
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol VirtualOrderListCellDelegate;
@interface VirtualOrderListCell : WXUITableViewCell
@property (nonatomic,weak)id<VirtualOrderListCellDelegate>  delegate;
+ (instancetype)VirtualOrderListCellWithTabelView:(UITableView*)tableView;
@end


@protocol VirtualOrderListCellDelegate <NSObject>
- (void)confirmGoodsBtn:(NSInteger)orderID;
@end