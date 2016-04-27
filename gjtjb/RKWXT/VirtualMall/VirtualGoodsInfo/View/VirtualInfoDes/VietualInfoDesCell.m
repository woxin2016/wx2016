//
//  VietualInfoDesCell.m
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VietualInfoDesCell.h"
#import "VirtualGoodsInfoEntity.h"

@interface VietualInfoDesCell ()
{
    WXUILabel *desLabel;
    WXUILabel *shopPrice;
    WXUILabel *marketPrice;
    WXUILabel *lineLabel;
    WXUILabel *postgateL;
    UILabel *markPL;
    UIView *markDidView;
}
@end

@implementation VietualInfoDesCell

+ (instancetype)VietualInfoDesCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VietualInfoDesCell";
    VietualInfoDesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VietualInfoDesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        [desLabel setFont:WXFont(14.0)];
        [desLabel setTextColor:WXColorWithInteger(0x000000)];
        desLabel.numberOfLines = 2;
        [self.contentView addSubview:desLabel];
        
        yOffset += desHeight + 3;
        CGFloat priceLabelWidth = 120;
        CGFloat priceLabelHeight = 20;
        shopPrice = [[WXUILabel alloc] init];
        shopPrice.frame = CGRectMake(xOffset, yOffset, priceLabelWidth + 60, priceLabelHeight);
        [shopPrice setBackgroundColor:[UIColor clearColor]];
        [shopPrice setTextAlignment:NSTextAlignmentLeft];
        [shopPrice setTextColor:WXColorWithInteger(AllBaseColor)];
        [shopPrice setFont:WXFont(15.0)];
        [self.contentView addSubview:shopPrice];
        
        
        yOffset += priceLabelHeight + 5;
        CGFloat markH = 15;
        CGFloat maLW = 50;
        UILabel *maLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, maLW, markH)];
        maLabel.font = WXFont(15.0);
        maLabel.textAlignment = NSTextAlignmentLeft;
        maLabel.textColor = [UIColor redColor];
        maLabel.text = @"市场价:";
        [self.contentView addSubview:maLabel];
        
        markPL = [[UILabel alloc]initWithFrame:CGRectMake(maLabel.right, yOffset,priceLabelWidth + 20- maLW, markH)];
        markPL.font = WXFont(14.0);
        markPL.textAlignment = NSTextAlignmentLeft;
        markPL.textColor = [UIColor redColor];
        [self.contentView addSubview:markPL];
        
        markDidView = [[UIView alloc]init];
        markDidView.backgroundColor = [UIColor redColor];
        [markPL addSubview:markDidView];
        
        
        yOffset += markH + 4;
        marketPrice = [[WXUILabel alloc] init];
        marketPrice.frame = CGRectMake(xOffset, yOffset, priceLabelWidth + 20, priceLabelHeight);
        [marketPrice setBackgroundColor:[UIColor clearColor]];
        [marketPrice setTextAlignment:NSTextAlignmentLeft];
        [marketPrice setTextColor:WXColorWithInteger(0x9b9b9b)];
        [marketPrice setFont:WXFont(13.0)];
        [self.contentView addSubview:marketPrice];
        
        xOffset = self.width - 80 - 10;
        postgateL = [[WXUILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, 80, priceLabelWidth)];
        postgateL.centerY = marketPrice.centerY;
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
    
    markPL.text = [NSString stringWithFormat:@"￥%.2f",entity.marketPrice];
    markDidView.frame = CGRectMake(0, markPL.height / 2 - 0.5 , [NSString sizeWithString:markPL.text font:markPL.font].width, 0.5);
}

- (void)backMoney:(CGFloat)money xnb:(int)xnb{
    [marketPrice setText:[NSString stringWithFormat:@"返现金额:￥%.2f",money]];
    NSString *marketPriceString = [NSString stringWithFormat:@"所需云票:%d",xnb];  //￥金额符号
    [shopPrice setText:marketPriceString];
   
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}


@end
