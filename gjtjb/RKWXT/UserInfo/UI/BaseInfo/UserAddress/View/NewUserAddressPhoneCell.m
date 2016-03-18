//
//  NewUserAddressPhoneCell.m
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "NewUserAddressPhoneCell.h"

@interface NewUserAddressPhoneCell()<UITextFieldDelegate>{
    WXUITextField *_textField;
}
@end

@implementation NewUserAddressPhoneCell
@synthesize textLabelWidth = _textLabelWidth;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xOffset = 10;
        CGFloat height = 20;
        CGFloat nameWidth = 80;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (44-height)/2, nameWidth, 20);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"收货人电话:"];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x484848)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        xOffset += nameWidth;
        _textField = [[WXUITextField alloc] initWithFrame:CGRectMake(xOffset, (44-height)/2+1, 160, height)];
        [_textField setTextAlignment:NSTextAlignmentLeft];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setTextColor:WXColorWithInteger(0x484848)];
        [_textField setFont:WXFont(12.0)];
        [_textField setPlaceholder:@"请输入收货人电话"];
        [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
        [_textField addTarget:self action:@selector(textValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [_textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:_textField];
    }
    return self;
}

-(void)load{
    [_textField setPlaceholder:_alertText];
    NSString *phone = self.cellInfo;
    if(phone){
        [_textField setText:phone];
    }
}

- (void)textValueDidChanged:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(textFiledPhoneValueDidChanged:)]){
        [_delegate textFiledPhoneValueDidChanged:_textField.text];
    }
}

-(void)textFieldDone:(id)sender{
    [sender resignFirstResponder];
}

@end
