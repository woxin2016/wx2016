//
//  NewAddressTextfieldCell.h
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol NewTextFieldCellDelegate;
@interface NewAddressTextfieldCell : WXUITableViewCell
//默认为100
@property (nonatomic,assign)CGFloat textLabelWidth;
@property (nonatomic,readonly)WXUITextField *textField;
@property (nonatomic,strong) NSString *alertText;
@property (nonatomic,assign)id<NewTextFieldCellDelegate>delegate;
@end

@protocol NewTextFieldCellDelegate <NSObject>
@optional
- (void)textFiledValueDidChanged:(NSString*)text;

@end
