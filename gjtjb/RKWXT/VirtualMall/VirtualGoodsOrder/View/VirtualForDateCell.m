//
//  VirtualForDateCell.m
//  RKWXT
//
//  Created by app on 16/4/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualForDateCell.h"
#import "VirtualOrderInfoEntity.h"

@interface VirtualForDateCell(){
    UILabel *_uptextLabel;
    UILabel *_money;
    UILabel *_dateLabel;
}
@end

@implementation VirtualForDateCell

+ (instancetype)VirtualForDateCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualForDateCell";
    VirtualForDateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualForDateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat xGap = 140;
        CGFloat yOffset = 12;
        CGFloat upHeight = 20;
        CGFloat labelWidth = 55;
        _uptextLabel = [[UILabel alloc] init];
        _uptextLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, yOffset, labelWidth, upHeight);
        [_uptextLabel setBackgroundColor:[UIColor clearColor]];
        [_uptextLabel setTextAlignment:NSTextAlignmentLeft];
        [_uptextLabel setText:@"实付款:"];
        [_uptextLabel setTextColor:WXColorWithInteger(0x000000)];
        [_uptextLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:_uptextLabel];
        
        xGap -= labelWidth;
        _money = [[UILabel alloc] init];
        _money.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, yOffset, IPHONE_SCREEN_WIDTH-xGap, upHeight);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentLeft];
        [_money setFont:WXFont(15.0)];
        [_money setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:_money];
        
        yOffset += upHeight+8;
        CGFloat xOffset = 170;
        CGFloat dateWidth = 50;
        CGFloat dateHeight = 15;
        UILabel *datelabel = [[UILabel alloc] init];
        datelabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset, yOffset, dateWidth, dateHeight);
        [datelabel setBackgroundColor:[UIColor clearColor]];
        [datelabel setTextAlignment:NSTextAlignmentLeft];
        [datelabel setTextColor:WXColorWithInteger(0x787978)];
        [datelabel setFont:WXFont(11.0)];
        [datelabel setText:@"下单时间:"];
        [self.contentView addSubview:datelabel];
        
        xOffset -= dateWidth;
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset, yOffset, IPHONE_SCREEN_WIDTH-xOffset, dateHeight);
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setTextAlignment:NSTextAlignmentLeft];
        [_dateLabel setTextColor:WXColorWithInteger(0x787978)];
        [_dateLabel setFont:WXFont(11.0)];
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

- (void)load{
    NSInteger time = [UtilTool timeChange];
    [_dateLabel setText:[UtilTool getDateTimeFor:time type:1]];
    
    VirtualOrderInfoEntity *entity = self.cellInfo;
    NSString *moneyStr = [NSString stringWithFormat:@"￥%.2f",(entity.postage + entity.goodsPrice)];
    [_money setText:moneyStr];
    [self labelWidthMonery:moneyStr];
}


- (void)labelWidthMonery:(NSString*)monery{
    CGFloat margin = 10;
    CGFloat labelW = [NSString sizeWithString:monery font:_money.font].width;
    _money.X = self.width - margin - labelW;
    _uptextLabel.X = self.width - 2 * margin - labelW - 55;
}

+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 60;
}

@end
