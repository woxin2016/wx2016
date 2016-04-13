//
//  VirtualOrderAllMoneyCell.m
//  RKWXT
//
//  Created by app on 16/4/12.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualOrderAllMoneyCell.h"
#import "virtualOrderListEntity.h"

@interface VirtualOrderAllMoneyCell ()
{
    UILabel *_money;
    UILabel *_bonus;
    UILabel *_xnb;
    UILabel *_carriage;
}
@end

@implementation VirtualOrderAllMoneyCell

+ (instancetype)VirtualOrderAllMoneyCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualOrderAllMoneyCell";
    VirtualOrderAllMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualOrderAllMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat xOffset = 12;
        CGFloat yOffset = 12;
        CGFloat width = 90;
        CGFloat height = 15;
        UILabel *textLabel1 = [[UILabel alloc] init];
        textLabel1.frame = CGRectMake(xOffset, yOffset, width, height);
        [textLabel1 setBackgroundColor:[UIColor clearColor]];
        [textLabel1 setTextAlignment:NSTextAlignmentLeft];
        [textLabel1 setFont:WXFont(12.0)];
        [textLabel1 setText:@"商品总额"];
        [textLabel1 setTextColor:WXColorWithInteger(0x646464)];
        [self.contentView addSubview:textLabel1];
        
        CGFloat xGap = 12;
        _money = [[UILabel alloc] init];
        _money.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-width, yOffset, width, height);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentRight];
        [_money setFont:WXFont(12.0)];
        [_money setTextColor:WXColorWithInteger(AllBaseColor)];
        [self.contentView addSubview:_money];
        
        yOffset += height+8;
        //        UILabel *textLabel2 = [[UILabel alloc] init];
        //        textLabel2.frame = CGRectMake(xOffset, yOffset, width, height);
        //        [textLabel2 setBackgroundColor:[UIColor clearColor]];
        //        [textLabel2 setTextAlignment:NSTextAlignmentLeft];
        //        [textLabel2 setFont:WXFont(11.0)];
        //        [textLabel2 setText:@"余额:"];
        //        [textLabel2 setTextColor:WXColorWithInteger(0x6a6c6b)];
        //        [self.contentView addSubview:textLabel2];
        //
        //        _bonus = [[UILabel alloc] init];
        //        _bonus.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-width, yOffset, width, height);
        //        [_bonus setBackgroundColor:[UIColor clearColor]];
        //        [_bonus setTextAlignment:NSTextAlignmentRight];
        //        [_bonus setFont:WXFont(11.0)];
        //        [_bonus setTextColor:WXColorWithInteger(AllBaseColor)];
        //        [self.contentView addSubview:_bonus];
        //
        //        yOffset += height+8;
        UILabel *textLabel3 = [[UILabel alloc] init];
        textLabel3.frame = CGRectMake(xOffset, yOffset, width, height);
        [textLabel3 setBackgroundColor:[UIColor clearColor]];
        [textLabel3 setTextAlignment:NSTextAlignmentLeft];
        [textLabel3 setFont:WXFont(11.0)];
        [textLabel3 setText:@"-云票:"];
        [textLabel3 setTextColor:WXColorWithInteger(0x6a6c6b)];
        [self.contentView addSubview:textLabel3];
        
        _xnb = [[UILabel alloc] init];
        _xnb.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-width, yOffset, width, height);
        [_xnb setBackgroundColor:[UIColor clearColor]];
        [_xnb setTextAlignment:NSTextAlignmentRight];
        [_xnb setFont:WXFont(11.0)];
        [_xnb setTextColor:WXColorWithInteger(AllBaseColor)];
        [self.contentView addSubview:_xnb];
        
        yOffset += height+8;
        UILabel *textLabel4 = [[UILabel alloc] init];
        textLabel4.frame = CGRectMake(xOffset, yOffset, width, height);
        [textLabel4 setBackgroundColor:[UIColor clearColor]];
        [textLabel4 setTextAlignment:NSTextAlignmentLeft];
        [textLabel4 setFont:WXFont(11.0)];
        [textLabel4 setText:@"+运费:"];
        [textLabel4 setTextColor:WXColorWithInteger(0x6a6c6b)];
        [self.contentView addSubview:textLabel4];
        
        _carriage = [[UILabel alloc] init];
        _carriage.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-width, yOffset, width, height);
        [_carriage setBackgroundColor:[UIColor clearColor]];
        [_carriage setTextAlignment:NSTextAlignmentRight];
        [_carriage setFont:WXFont(11.0)];
        [_carriage setTextColor:WXColorWithInteger(AllBaseColor)];
        [self.contentView addSubview:_carriage];
    }
    return self;
}

- (void)load{
    virtualOrderListEntity *entity = self.cellInfo;
    
    NSString *bonusStr = [NSString stringWithFormat:@"%.2f",entity.goodsPrice];
    [_money setText:bonusStr];
    
    NSString *xnb = [NSString stringWithFormat:@"-%.d",entity.xnb];
    [_xnb setText:xnb];
    
    NSString *carriageStr = [NSString stringWithFormat:@"+%.2f",entity.posgate];
    [_carriage setText:carriageStr];
}


+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 85;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

@end
