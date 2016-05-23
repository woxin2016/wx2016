//
//  XNBPassWordCell.m
//  RKWXT
//
//  Created by app on 16/5/23.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "XNBPassWordCell.h"

@interface XNBPassWordCell ()<UITextFieldDelegate>{
    WXUITextField *_textField;
}
@end

@implementation XNBPassWordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat xOffset = 14;
        CGFloat height = 20;
        CGFloat nameWidth = 55;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (44-height)/2, nameWidth, 20);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"密码:"];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x484848)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        xOffset += nameWidth;
        CGFloat textHeight = 17;
        _textField = [[WXUITextField alloc] initWithFrame:CGRectMake(xOffset, (44-textHeight)/2+1, 170, textHeight)];
        [_textField setTextAlignment:NSTextAlignmentLeft];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setFont:WXFont(12.0)];
        [_textField setPlaceholder:@"请输入密码"];
        [_textField setTextColor:WXColorWithInteger(0x484848)];
        [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
        [_textField addTarget:self action:@selector(textValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [_textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:_textField];
    }
    return self;
}

- (void)textValueDidChanged:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(textFiledPassWordValueDidChanged:)]){
        [_delegate textFiledPassWordValueDidChanged:_textField.text];
    }
}

-(void)textFieldDone:(id)sender{
    [sender resignFirstResponder];
}

@end
