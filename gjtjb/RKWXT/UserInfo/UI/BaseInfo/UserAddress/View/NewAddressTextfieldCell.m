//
//  NewAddressTextfieldCell.m
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "NewAddressTextfieldCell.h"

@interface NewAddressTextfieldCell()<UITextFieldDelegate>{
    WXUITextField *_textField;
}
@end

@implementation NewAddressTextfieldCell
@synthesize textLabelWidth = _textLabelWidth;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xOffset = 10;
        CGFloat height = 20;
        CGFloat nameWidth = 55;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (44-height)/2, nameWidth, 20);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"收货人:"];
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
        [_textField setPlaceholder:@"请输入收货人姓名"];
        [_textField setTextColor:WXColorWithInteger(0x484848)];
        [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
        [_textField addTarget:self action:@selector(textValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [_textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:_textField];
    }
    return self;
}

-(void)load{
    [_textField setPlaceholder:_alertText];
    NSString *name = self.cellInfo;
    if(name){
        [_textField setText:name];
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
