//
//  PersonalNickNameCell.h
//  RKWXT
//
//  Created by SHB on 16/3/17.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol PersonalNickNameCellDelegate;

@interface PersonalNickNameCell : WXUITableViewCell
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,weak) id<PersonalNickNameCellDelegate>delegate;

@end

@protocol PersonalNickNameCellDelegate <NSObject>
-(void)personalNickNameTextFieldChanged:(PersonalNickNameCell*)cell;

@end
