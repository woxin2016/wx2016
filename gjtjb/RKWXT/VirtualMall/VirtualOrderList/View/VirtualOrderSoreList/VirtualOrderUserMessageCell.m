//
//  VirtualOrderUserMessageCell.m
//  RKWXT
//
//  Created by app on 16/4/13.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualOrderUserMessageCell.h"

@interface VirtualOrderUserMessageCell ()
{
    UILabel *messageL;
}
@end

@implementation VirtualOrderUserMessageCell

+ (instancetype)VirtualOrderUserMessageCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualOrderUserMessageCell";
    VirtualOrderUserMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualOrderUserMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        CGFloat messW  =self.width - 30 - labelW;
        messageL = [[UILabel alloc]initWithFrame:CGRectMake(label.right + 10, 0, messW, self.height)];
        messageL.font = WXFont(14.0);
        messageL.textAlignment = NSTextAlignmentLeft;
        messageL.textColor = WXColorWithInteger(0x646464);
        [self.contentView addSubview:messageL];
        
    }
    return self;
}

- (void)load{
    
    NSString *mess = self.cellInfo;
     messageL.text = mess;
//    CGFloat height = [NSString sizeWithString:mess font:messageL.font].height;
    
}

+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
    NSString *mess = cellInfo;
    CGFloat height = [NSString sizeWithString:mess font:[UIFont systemFontOfSize:14.0]].height;
    return height;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

@end
