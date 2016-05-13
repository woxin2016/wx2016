//
//  BalanceAccountCell.m
//  RKWXT
//
//  Created by app on 16/5/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "BalanceAccountCell.h"

@interface BalanceAccountCell ()
{
    WXUITextField *_textField;
}
@end

@implementation BalanceAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imageView.image = [UIImage imageNamed:@"iv_card.png"];
        
        CGFloat xOffset = 40;
        CGFloat height = 20;
        CGFloat nameWidth = 65;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (44-height)/2, nameWidth, 20);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"卡号:"];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:[UIColor colorWithHexString:@"#373737"]];
        [nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:nameLabel];
        
        xOffset += nameWidth + 10;
        CGFloat textHeight = 17;
        _textField = [[WXUITextField alloc] initWithFrame:CGRectMake(xOffset, (44-textHeight)/2+1, 170, textHeight)];
        [_textField setTextAlignment:NSTextAlignmentLeft];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setFont:WXFont(15.0)];
        [_textField setPlaceholder:@"请输入充值卡号"];
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
    if(_delegate && [_delegate respondsToSelector:@selector(accountTextFiledPhoneValueDidChanged:)]){
        [_delegate accountTextFiledPhoneValueDidChanged:_textField.text];
    }
}

-(void)textFieldDone:(id)sender{
    [sender resignFirstResponder];
}

@end