//
//  VirtualGoodsListCell.m
//  RKWXT
//
//  Created by app on 16/4/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualGoodsListCell.h"
#import "WXRemotionImgBtn.h"
#import "VirtualGoodsInfoEntity.h"
#import "VirtualOrderInfoEntity.h"

@interface VirtualGoodsListCell(){
    WXRemotionImgBtn *_imgView;
    UILabel *_nameLabel;
    UILabel *_stockName;
    UILabel *_priceLabel;
    UILabel *_buyNumber;
}
@end

@implementation VirtualGoodsListCell

+ (instancetype)VirtualGoodsListCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualGoodsListCell";
    VirtualGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualGoodsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat xOffset = 12;
        CGFloat imgWidth = 70;
        CGFloat imgHeight = imgWidth;
        CGFloat yOffset =  ([VirtualGoodsListCell cellHeightOfInfo:nil]-imgHeight)/2;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset,yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+10;
        yOffset -= 3;
        CGFloat nameWidth = self.width - xOffset - 10;
        CGFloat nameHeight = 38;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:WXFont(15.0)];
        [_nameLabel setNumberOfLines:2];
        [self.contentView addSubview:_nameLabel];
        
        yOffset += nameHeight + 3;
        CGFloat stockH = 15;
        _stockName = [[UILabel alloc] init];
        _stockName.frame = CGRectMake(xOffset, yOffset, nameWidth - 40, stockH);
        [_stockName setBackgroundColor:[UIColor clearColor]];
        [_stockName setTextAlignment:NSTextAlignmentLeft];
        [_stockName setTextColor:WXColorWithInteger(0x000000)];
        [_stockName setFont:WXFont(13.0)];
        [self.contentView addSubview:_stockName];
        
        CGFloat numberW = 40;
        CGFloat buyX = self.width - 10 - numberW;
        _buyNumber = [[UILabel alloc] init];
        _buyNumber.frame = CGRectMake(buyX, yOffset, numberW, 15);
        [_buyNumber setBackgroundColor:[UIColor clearColor]];
        [_buyNumber setTextAlignment:NSTextAlignmentRight];
        [_buyNumber setTextColor:WXColorWithInteger(0x000000)];
        [_buyNumber setFont:WXFont(13.0)];
        [self.contentView addSubview:_buyNumber];
        
        yOffset += stockH + 5;
        CGFloat priceWidth = 120;
        CGFloat priceHeight = 15;
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.frame = CGRectMake(xOffset, yOffset, priceWidth, priceHeight);
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [_priceLabel setTextAlignment:NSTextAlignmentLeft];
        [_priceLabel setTextColor:[UIColor redColor]];
        [_priceLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_priceLabel];
        
    }
    return self;
}

- (void)load{
    VirtualOrderInfoEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:entity.goodsImg];
    [_imgView load];
    
    [_nameLabel setText:entity.goodsName];
    _stockName.text = entity.stockName;
    int price = entity.buyNumber * entity.xnbPrice;
    [_priceLabel setText:[NSString stringWithFormat:@"所需云票%d",price]];
    
    _buyNumber.text = [NSString stringWithFormat:@"X %d",entity.buyNumber];
}


+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 95;
}


@end
