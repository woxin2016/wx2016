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
        CGFloat imgWidth = 63;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, ([VirtualGoodsListCell cellHeightOfInfo:nil]-imgHeight)/2, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+13;
        CGFloat yOffset = ([VirtualGoodsListCell cellHeightOfInfo:nil]-imgHeight)/2+2;
        CGFloat nameWidth = 135;
        CGFloat nameHeight = 45;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setNumberOfLines:0];
        [_nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:_nameLabel];
        
        CGFloat yGap = [VirtualGoodsListCell cellHeightOfInfo:nil]-([VirtualGoodsListCell cellHeightOfInfo:nil]-imgHeight)/2-16;
        _stockName = [[UILabel alloc] init];
        _stockName.frame = CGRectMake(xOffset, yGap, 100, 18);
        [_stockName setBackgroundColor:[UIColor clearColor]];
        [_stockName setTextAlignment:NSTextAlignmentLeft];
        [_stockName setTextColor:WXColorWithInteger(0x000000)];
        [_stockName setNumberOfLines:0];
        [_stockName setFont:WXFont(13.0)];
        [self.contentView addSubview:_stockName];
        
        
        CGFloat priceWidth = 80;
        CGFloat priceHeight = 17;
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-priceWidth-10, yOffset, priceWidth, priceHeight);
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [_priceLabel setTextAlignment:NSTextAlignmentRight];
        [_priceLabel setTextColor:WXColorWithInteger(0x000000)];
        [_priceLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_priceLabel];
    }
    return self;
}

- (void)load{
    VirtualOrderInfoEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:entity.goodsImg];
    [_imgView load];
    [_nameLabel setText:entity.stockName];
    CGFloat price = entity.buyNumber * entity.goodsPrice;
    [_priceLabel setText:[NSString stringWithFormat:@"￥%.2f",price]];
}


+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 95;
}


@end
