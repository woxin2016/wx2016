//
//  VirtualPayXNBCell.m
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualPayXNBCell.h"

@interface VirtualPayXNBCell ()
{
    UILabel *_moneyL;
    UISwitch *_openSwitch;
}
@end

@implementation VirtualPayXNBCell

+ (instancetype)VirtualPayXNBCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualPayXNBCell";
    VirtualPayXNBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualPayXNBCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat xOffset = 10;
        CGFloat labelW = 40;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 0, labelW, self.height)];
        label.text = @"云票";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = WXFont(14.0);
        label.textColor = WXColorWithInteger(0x646464);
        [self.contentView addSubview:label];
        
        _moneyL = [[UILabel alloc]initWithFrame:CGRectMake(label.right, 0, 150, self.height)];
        _moneyL.textAlignment = NSTextAlignmentLeft;
        _moneyL.font = WXFont(13.0);
        _moneyL.textColor = WXColorWithInteger(0x646464);
        [self.contentView addSubview:_moneyL];
        
//        CGFloat switchW = 60;
//        CGFloat witchH = 20;
//        CGFloat yoffset = (self.height - witchH ) / 2;
//        _openSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(self.width - xOffset - switchW, yoffset, switchW, witchH)];
//        [self.contentView addSubview:_openSwitch];
    }
    return self;
}

- (void)userCanXNB:(NSInteger)XNB{
    _moneyL.text = [NSString stringWithFormat:@"共有%.d云票",XNB];
}



@end
