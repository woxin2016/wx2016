//
//  VirtualUserMessageCell.h
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol VirtualUserMessageCellDelegate <NSObject>
- (void)userMessageTextFieldChanged:(NSString*)message;
@end

@interface VirtualUserMessageCell : WXUITableViewCell
@property (nonatomic,weak) id<VirtualUserMessageCellDelegate> delegate;
+ (instancetype)VirtualUserMessageCellWithTabelView:(UITableView*)tableView;
@end
