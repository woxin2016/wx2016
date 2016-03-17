//
//  PersonalNickNameCell.m
//  RKWXT
//
//  Created by SHB on 16/3/17.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "PersonalNickNameCell.h"
#import "BaseInfoDef.h"

@implementation PersonalNickNameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat xOffset = 15;
        CGFloat textHeight = 20;
        CGFloat nameWidth = 45;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (BaseInfoForCommonCellHeight-textHeight)/2, nameWidth, textHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"昵称"];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:nameLabel];
        
        xOffset += nameWidth;
        CGFloat textfieldWidth = 180;
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(xOffset, (BaseInfoForCommonCellHeight-textHeight)/2, textfieldWidth, textHeight);
        [_textField setBackgroundColor:[UIColor clearColor]];
        [_textField setTextAlignment:NSTextAlignmentLeft];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setPlaceholder:@"请输入您的昵称(不超过15个字符)"];
        [_textField setFont:WXFont(12.0)];
        [_textField setTextColor:WXColorWithInteger(0xbababa)];
        [_textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_textField addTarget:self action:@selector(textfieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [_textField addTarget:self action:@selector(textFiledValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_textField];
        
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(xOffset, _textField.frame.origin.y+textHeight+2, textfieldWidth, 0.5);
        [lineLabel setBackgroundColor:WXColorWithInteger(0xbababa)];
        [self.contentView addSubview:lineLabel];
    }
    return self;
}

-(void)textfieldDone:(id)sender{
    [sender resignFirstResponder];
}

-(void)load{
    NSString *nickName = self.cellInfo;
    if(nickName){
        [_textField setText:nickName];
    }
}

-(void)textFiledValueDidChanged:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(personalNickNameTextFieldChanged:)]){
        [_delegate personalNickNameTextFieldChanged:self];
    }
}

@end
