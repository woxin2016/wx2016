//
//  VirtualPayMoneryCell.m
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualPayMoneryCell.h"

@interface VirtualPayMoneryCell ()
{
    UILabel *_moneyL;
    UISwitch *_openSwitch;
}
@end

@implementation VirtualPayMoneryCell

+ (instancetype)VirtualPayMoneryCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualPayMoneryCell";
    VirtualPayMoneryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualPayMoneryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.height = 44;
        
        CGFloat xOffset = 10;
        CGFloat labelW = 40;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 0, labelW, self.height)];
        label.text = @"余额";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = WXFont(13.0);
        [self.contentView addSubview:label];
        
        _moneyL = [[UILabel alloc]initWithFrame:CGRectMake(label.right, 0, 150, self.height)];
        _moneyL.textAlignment = NSTextAlignmentLeft;
        _moneyL.font = WXFont(14.0);
        [self.contentView addSubview:_moneyL];
        
        CGFloat switchW = 60;
        CGFloat witchH = 20;
        CGFloat yoffset = (self.height - witchH ) / 2;
        _openSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(self.width - xOffset - switchW, yoffset, switchW, witchH)];
        [self.contentView addSubview:_openSwitch];
    }
    return self;
}

- (void)userCanMonery:(CGFloat)monery{
    _moneyL.text = [NSString stringWithFormat:@"可用余额:￥%.2f",monery];
}

@end
