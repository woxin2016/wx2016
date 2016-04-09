//
//  VirtualPayStatusCell.m
//  RKWXT
//
//  Created by app on 16/4/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualPayStatusCell.h"

@implementation VirtualPayStatusCell

+ (instancetype)VirtualPayStatusCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualPayStatusCell";
    VirtualPayStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualPayStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat xOffset = 12;
        CGFloat labelWidth = 120;
        CGFloat labelHeight = 15;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(xOffset, ([VirtualPayStatusCell cellHeightOfInfo:nil]-labelHeight)/2, labelWidth, labelHeight);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:WXColorWithInteger(0x646464)];
        [label setFont:WXFont(14.0)]; 
        [label setText:@"支付方式"];
        [self.contentView addSubview:label];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-labelWidth, ([VirtualPayStatusCell cellHeightOfInfo:nil] -labelHeight)/2, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentRight];
        [nameLabel setText:@"在线支付"];
        [nameLabel setFont:WXFont(14.0)];
        [nameLabel setTextColor:WXColorWithInteger(0x646464)];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 44;
}


@end
