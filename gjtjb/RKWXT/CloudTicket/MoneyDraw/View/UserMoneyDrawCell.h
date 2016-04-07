//
//  UserMoneyDrawCell.h
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define UserMoneyDrawCellHeight (42)

@protocol UserMoneyDrawCellDelegate;
@interface UserMoneyDrawCell : WXUITableViewCell
//默认为100
@property (nonatomic,readonly) WXUITextField *textField;
@property (nonatomic,weak) id<UserMoneyDrawCellDelegate>delegate;
@end

@protocol UserMoneyDrawCellDelegate <NSObject>
@optional
- (void)textFiledValueDidChanged:(NSString*)text;

@end
