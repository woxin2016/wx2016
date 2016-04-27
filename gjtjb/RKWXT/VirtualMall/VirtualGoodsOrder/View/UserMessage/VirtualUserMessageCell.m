//
//  VirtualUserMessageCell.m
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualUserMessageCell.h"

@interface VirtualUserMessageCell ()
{
    UITextField *_field;
}
@end

@implementation VirtualUserMessageCell

+ (instancetype)VirtualUserMessageCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualUserMessageCell";
    VirtualUserMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualUserMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat labelW = 80;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, labelW, self.height)];
        label.font = WXFont(14.0);
        label.text = @"买家留言:";
        label.textColor = WXColorWithInteger(0x646464);
        [self.contentView addSubview:label];
        
        _field = [[UITextField alloc]initWithFrame:CGRectMake(label.right, 0, self.width - 20 - labelW, self.height)];
        [_field setTextAlignment:NSTextAlignmentLeft];
        [_field setReturnKeyType:UIReturnKeyDone];
        [_field setPlaceholder:@"请输入备注信息"];
        [_field setFont:WXFont(13.0)];
        [_field setTextColor:WXColorWithInteger(0x646464)];
        [_field setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_field addTarget:self action:@selector(textfieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [_field addTarget:self action:@selector(textFiledValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_field];
        
    }
    return self;
}

- (void)textfieldDone:(id)sender{
    [sender resignFirstResponder];
}

-(void)textFiledValueDidChanged:(id)sender{
    UITextField *textField = sender;
    if(_delegate && [_delegate respondsToSelector:@selector(userMessageTextFieldChanged:)]){
        [_delegate userMessageTextFieldChanged:textField.text];
    }
}



@end
