//
//  NewAddressInfoCell.m
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "NewAddressInfoCell.h"

@interface NewAddressInfoCell()<UITextFieldDelegate>{
    WXUITextField *_textField;
}
@end

@implementation NewAddressInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat height = 20;
        CGFloat nameWidth = 70;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (44-height)/2, nameWidth, 20);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"详细地址:"];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x484848)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        xOffset += nameWidth;
        CGFloat textheight = 17;
        _textField = [[WXUITextField alloc] initWithFrame:CGRectMake(xOffset, (NewAddressInfoCellHeight-height)/2+2, 160, textheight)];
        [_textField setTextAlignment:NSTextAlignmentLeft];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setTextColor:WXColorWithInteger(0x484848)];
        [_textField setFont:WXFont(12.0)];
        [_textField setPlaceholder:@"请输入详细地址"];
        [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
        [_textField addTarget:self action:@selector(textValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [_textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:_textField];
    }
    return self;
}

-(void)load{
    NSString *address = self.cellInfo;
    if(address){
        [_textField setText:address];
    }
}

- (void)textValueDidChanged:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(textViewValueDidChanged:)]){
        [_delegate textViewValueDidChanged:_textField.text];
    }
}

-(void)textFieldDone:(id)sender{
    [sender resignFirstResponder];
}

@end
