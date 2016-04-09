//
//  UserMoneyDrawCell.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserMoneyDrawCell.h"

@interface UserMoneyDrawCell()<UITextFieldDelegate>{
    WXUITextField *_textField;
}
@end

@implementation UserMoneyDrawCell
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xOffset = 10;
        CGFloat height = 20;
        CGFloat nameWidth = 40;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (UserMoneyDrawCellHeight-height)/2, nameWidth, height);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"提现:"];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x5c615d)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        xOffset += nameWidth;
        _textField = [[WXUITextField alloc] init];
        _textField.frame = CGRectMake(xOffset, (UserMoneyDrawCellHeight-height)/2, 200, height);
        [_textField setTextAlignment:NSTextAlignmentLeft];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setTextColor:WXColorWithInteger(0x9c9c9c)];
        [_textField setFont:WXFont(14.0)];
        [_textField setPlaceHolder:@"请输入您需要提现的金额" color:WXColorWithInteger(0x9c9c9c)];
        [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
        [_textField addTarget:self action:@selector(textValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [_textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:_textField];
    }
    return self;
}

-(void)load{
    NSString *phone = self.cellInfo;
    if(phone){
        [_textField setText:phone];
    }
}

- (void)textValueDidChanged:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(textFiledValueDidChanged:)]){
        [_delegate textFiledValueDidChanged:_textField.text];
    }
}

-(void)textFieldDone:(id)sender{
    [sender resignFirstResponder];
}

@end
