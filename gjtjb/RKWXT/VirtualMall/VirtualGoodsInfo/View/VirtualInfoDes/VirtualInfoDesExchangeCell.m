//
//  VirtualInfoDesExchangeCell.m
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualInfoDesExchangeCell.h"
#import "VirtualGoodsInfoEntity.h"

@interface VirtualInfoDesExchangeCell ()
{
    WXUILabel *desLabel;
    WXUILabel *shopPrice;
    WXUILabel *marketPrice;
    WXUILabel *backMoneyl;
    WXUILabel *lineLabel;
    WXUILabel *postgateL;
    UIView *markDidView;
}
@end

@implementation VirtualInfoDesExchangeCell

+ (instancetype)VirtualInfoDesExchangeCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualInfoDesExchangeCell";
    VirtualInfoDesExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualInfoDesExchangeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat xOffset = 12;
        CGFloat yOffset = 10;
        CGFloat desWidth = IPHONE_SCREEN_WIDTH-2*xOffset - 60;
        CGFloat desHeight = 35;
        desLabel = [[WXUILabel alloc] init];
        desLabel.frame = CGRectMake(xOffset, yOffset, desWidth, desHeight);
        [desLabel setBackgroundColor:[UIColor clearColor]];
        [desLabel setTextAlignment:NSTextAlignmentLeft];
        desLabel.numberOfLines = 2;
        [desLabel setFont:WXFont(14.0)];
        [desLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:desLabel];
        
        yOffset += desHeight + 3;
        CGFloat priceLabelWidth = 160;
        CGFloat priceLabelHeight = 20;
        shopPrice = [[WXUILabel alloc] init];
        shopPrice.frame = CGRectMake(xOffset, yOffset, priceLabelWidth + 60, priceLabelHeight);
        [shopPrice setBackgroundColor:[UIColor clearColor]];
        [shopPrice setTextAlignment:NSTextAlignmentLeft];
        [shopPrice setTextColor:WXColorWithInteger(AllBaseColor)];
        [shopPrice setFont:WXFont(15.0)];
        [self.contentView addSubview:shopPrice];
        
        yOffset += priceLabelHeight + 3;
        CGFloat virW = 70;
        UILabel *virLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, virW, priceLabelHeight)];
        virLabel.font = WXFont(15.0);
        virLabel.textAlignment = NSTextAlignmentLeft;
        virLabel.textColor = [UIColor redColor];
        virLabel.text = @"官方价格:";
        [self.contentView addSubview:virLabel];
        
        marketPrice = [[WXUILabel alloc] init];
        marketPrice.frame = CGRectMake(virLabel.right, yOffset, priceLabelWidth + 60 - virW, priceLabelHeight);
        [marketPrice setBackgroundColor:[UIColor clearColor]];
        [marketPrice setTextAlignment:NSTextAlignmentLeft];
        [marketPrice setTextColor:WXColorWithInteger(AllBaseColor)];
        [marketPrice setFont:WXFont(15.0)];
        [self.contentView addSubview:marketPrice];
        
        markDidView = [[UIView alloc]init];
        markDidView.backgroundColor = [UIColor redColor];
        [marketPrice addSubview:markDidView];
        
        yOffset += priceLabelHeight + 3;
        backMoneyl = [[WXUILabel alloc] init];
        backMoneyl.frame = CGRectMake(xOffset, yOffset, priceLabelWidth + 20, priceLabelHeight);
        [backMoneyl setBackgroundColor:[UIColor clearColor]];
        [backMoneyl setTextAlignment:NSTextAlignmentLeft];
        [backMoneyl setTextColor:WXColorWithInteger(0x9b9b9b)];
        [backMoneyl setFont:WXFont(13.0)];
        [self.contentView addSubview:backMoneyl];
        
        
        xOffset += self.width - 80 - 10;
        postgateL = [[WXUILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, 80, priceLabelWidth)];
        postgateL.centerY = backMoneyl.centerY;
        [postgateL setBackgroundColor:[UIColor clearColor]];
        postgateL.textAlignment = NSTextAlignmentLeft;
        postgateL.textColor = [UIColor grayColor];
        postgateL.font = WXFont(13.0);
        [self.contentView addSubview:postgateL];
        
        
    }
    return self;
}

- (void)load{
    VirtualGoodsInfoEntity *entity = self.cellInfo;
    [desLabel setText:entity.goodsName];
    postgateL.text = [NSString stringWithFormat:@"邮费:￥%.2f",entity.postageVirtual];
    marketPrice.text = [NSString stringWithFormat:@"￥%.2f",entity.marketPrice];
    markDidView.frame = CGRectMake(0, marketPrice.height / 2 - 0.5 , [NSString sizeWithString:marketPrice.text font:marketPrice.font].width, 0.5);
}

- (void)backMoney:(CGFloat)money xnb:(int)xnb goodsPrice:(CGFloat)goodsPrice{
    [backMoneyl setText:[NSString stringWithFormat:@"返现金额:￥%.2f",money]];
    NSString *backMoneylString = [NSString stringWithFormat:@"价格:%.2f + %d云票",goodsPrice,xnb];  //￥金额符号
    [shopPrice setText:backMoneylString];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

@end