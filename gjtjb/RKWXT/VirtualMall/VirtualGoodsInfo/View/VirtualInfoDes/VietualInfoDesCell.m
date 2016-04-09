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
        CGFloat yOffset = 12;
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
        [shopPrice setFont:WXFont(16.0)];
        [self.contentView addSubview:shopPrice];
        
        yOffset += priceLabelHeight + 3;
        marketPrice = [[WXUILabel alloc] init];
        marketPrice.frame = CGRectMake(xOffset, yOffset, priceLabelWidth + 20, priceLabelHeight);
        [marketPrice setBackgroundColor:[UIColor clearColor]];
        [marketPrice setTextAlignment:NSTextAlignmentLeft];
        [marketPrice setTextColor:WXColorWithInteger(0x9b9b9b)];
        [marketPrice setFont:WXFont(14.0)];
        [self.contentView addSubview:marketPrice];
 
        lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(0, priceLabelHeight/2, priceLabelWidth/2, 0.5);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [marketPrice addSubview:lineLabel];
        
        xOffset += priceLabelWidth;
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
     NSString *marketPriceString = [NSString stringWithFormat:@"所需云票:￥%.2f",entity.marketPrice];  //￥金额符号
    [marketPrice setText:[NSString stringWithFormat:@"返现金额:￥%.2f",entity.shopPrice]];
    [shopPrice setText:marketPriceString];
    
    CGRect rectl = lineLabel.frame;
    rectl.size.width = [NSString sizeWithString:marketPrice.text font:marketPrice.font].width;
    [lineLabel setFrame:rectl];
    
    postgateL.text = [NSString stringWithFormat:@"邮费:￥%.2f",entity.postageVirtual];
}




@end
