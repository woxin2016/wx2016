//
//  LuckyOrderGoodsInfoCell.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyOrderGoodsInfoCell.h"
#import "WXRemotionImgBtn.h"
#import "LuckyOrderEntity.h"

@interface LuckyOrderGoodsInfoCell(){
    WXRemotionImgBtn *_goodsImg;
    UILabel *_goodsInfo;
    UILabel *_goodsPrice;
    UILabel *_infoLabel;
}
@end

@implementation LuckyOrderGoodsInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 10;
        CGFloat imgWidth = 65;
        CGFloat imgHeight = imgWidth;
        _goodsImg = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LuckyOrderGoodsInfoCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_goodsImg setUserInteractionEnabled:NO];
        [self.contentView addSubview:_goodsImg];
        
        xOffset += imgWidth+12;
        CGFloat yOffset = 16;
        CGFloat infoWidth = 140;
        CGFloat infoHeight = 40;
        _goodsInfo = [[UILabel alloc] init];
        _goodsInfo.frame = CGRectMake(xOffset, yOffset, infoWidth, infoHeight);
        [_goodsInfo setBackgroundColor:[UIColor clearColor]];
        [_goodsInfo setTextAlignment:NSTextAlignmentLeft];
        [_goodsInfo setTextColor:WXColorWithInteger(0x000000)];
        [_goodsInfo setFont:WXTFont(15.0)];
        [_goodsInfo setNumberOfLines:0];
        [self.contentView addSubview:_goodsInfo];
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.frame = CGRectMake(xOffset, yOffset+infoHeight, 150, 25);
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setFont:WXFont(12.0)];
        [_infoLabel setTextAlignment:NSTextAlignmentLeft];
        [_infoLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:_infoLabel];
        
        CGFloat xGap = 15;
        CGFloat priceWidth = 75;
        CGFloat priceHeight = 20;
        _goodsPrice = [[UILabel alloc] init];
        _goodsPrice.frame = CGRectMake(size.width-xGap-priceWidth, yOffset, priceWidth, priceHeight);
        [_goodsPrice setBackgroundColor:[UIColor clearColor]];
        [_goodsPrice setTextAlignment:NSTextAlignmentRight];
        [_goodsPrice setTextColor:WXColorWithInteger(0x000000)];
        [_goodsPrice setFont:WXTFont(14.0)];
        [self.contentView addSubview:_goodsPrice];
    }
    return self;
}

-(void)load{
    LuckyOrderEntity *entity = self.cellInfo;
    [_goodsImg setCpxViewInfo:entity.goods_img];
    [_goodsImg load];
    
    [_infoLabel setText:entity.goods_name];
    [_goodsInfo setText:entity.stockName];
    [_goodsPrice setText:[NSString stringWithFormat:@"%.2f",entity.market_price]];
}

@end
