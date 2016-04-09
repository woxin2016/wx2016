//
//  VirtualOrderNumberCell.m
//  RKWXT
//
//  Created by app on 16/4/9.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualOrderNumberCell.h"

@interface VirtualOrderNumberCell ()
{
    UILabel *orderNumber;
}
@end

@implementation VirtualOrderNumberCell

+ (instancetype)VirtualOrderNumberCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualOrderNumberCell";
    VirtualOrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualOrderNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat xOffset = 10;
        CGFloat labelW = 60;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 0, labelW, self.height)];
        label.font = WXFont(14.0);
        label.textColor = [UIColor blackColor];
        label.text = @"订单号:";
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        
        orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 0, 140, self.height)];
        orderNumber.font = WXFont(14.0);
        orderNumber.textColor = [UIColor blackColor];
        [self.contentView addSubview:orderNumber];
    }
    return self;
}

- (void)load{
    orderNumber.text = self.cellInfo;
}

@end
