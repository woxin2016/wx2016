//
//  UserMoneyDrawCell.h
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define UserMoneyDrawCellHeight (40)

@protocol UserMoneyDrawCellDelegate;
@interface UserMoneyDrawCell : WXUITableViewCell
//默认为100
@property (nonatomic,readonly) WXUITextField *textField;
@property (nonatomic,strong) NSString *alertText;
@property (nonatomic,weak) id<UserMoneyDrawCellDelegate>delegate;
@end

@protocol UserMoneyDrawCellDelegate <NSObject>
@optional
- (void)textFiledValueDidChanged:(NSString*)text;

@end
