//
//  XNBBalancePhoneCell.m
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "XNBBalancePhoneCell.h"

@interface XNBBalancePhoneCell ()
{
    WXUITextField *_textField;
}
@end

@implementation XNBBalancePhoneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
       
        CGFloat xOffset = 30 + 10;
        CGFloat height = 20;
        CGFloat nameWidth = 65;
//        WXUILabel *nameLabel = [[WXUILabel alloc] init];
//        nameLabel.frame = CGRectMake(xOffset, (44-height)/2, nameWidth, 20);
//        [nameLabel setBackgroundColor:[UIColor clearColor]];
//        [nameLabel setText:@"充值号码:"];
//        [nameLabel setTextAlignment:NSTextAlignmentLeft];
//        [nameLabel setTextColor:[UIColor colorWithHexString:@"#373737"]];
//        [nameLabel setFont:WXFont(15.0)];
//        [self.contentView addSubview:nameLabel];
       
        
        xOffset += nameWidth + 10;
        CGFloat textHeight = 17;
        WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
        _textField = [[WXUITextField alloc] initWithFrame:CGRectMake(xOffset, (44-textHeight)/2+1, 170, textHeight)];
        [_textField setTextAlignment:NSTextAlignmentLeft];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setFont:WXFont(15.0)];
        [_textField setText:userDefault.user];
        [_textField setTextColor:[UIColor colorWithHexString:@"#373737"]];
        [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
        [_textField addTarget:self action:@selector(textValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [_textField addTarget:self action:@selector(textValueDidChanged:) forControlEvents:UIControlEventEditingDidBegin];
        [_textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:_textField];
    }
    return self;
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


