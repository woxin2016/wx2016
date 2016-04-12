//
//  VirtualOrderDateCell.m
//  RKWXT
//
//  Created by app on 16/4/12.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualOrderDateCell.h"
#import "virtualOrderListEntity.h"

@interface VirtualOrderDateCell(){
    UILabel *_money;
    UILabel *_dateLabel;
}
@end

@implementation VirtualOrderDateCell

+ (instancetype)VirtualOrderDateCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualOrderDateCell";
    VirtualOrderDateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualOrderDateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat xGap = 140;
        CGFloat yOffset = 12;
        CGFloat upHeight = 20;
        CGFloat labelWidth = 55;
        UILabel *uptextLabel = [[UILabel alloc] init];
        uptextLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, yOffset, labelWidth, upHeight);
        [uptextLabel setBackgroundColor:[UIColor clearColor]];
        [uptextLabel setTextAlignment:NSTextAlignmentLeft];
        [uptextLabel setText:@"实付款:"];
        [uptextLabel setTextColor:WXColorWithInteger(0x000000)];
        [uptextLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:uptextLabel];
        
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
    virtualOrderListEntity *entity = self.cellInfo;
    _money.text = [NSString stringWithFormat:@"￥:%.2f",entity.monery];
    
    [_dateLabel setText:[self orderTime:entity.makeOrderTime]];
}

+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 60;
}

- (NSString*)orderTime:(NSTimeInterval)timeVal{
    NSDate *Date = [NSDate dateWithTimeIntervalSince1970:timeVal];
    
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [matter stringFromDate:Date];
}

@end