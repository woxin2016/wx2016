//
//  OrderInfoGoodsListCell.m
//  RKWXT
//
//  Created by SHB on 16/1/21.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "OrderInfoGoodsListCell.h"
#import "WXRemotionImgBtn.h"
#import "AllOrderListEntity.h"

@interface OrderInfoGoodsListCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *stockLabel;
    WXUILabel *priceLabel;
    WXUILabel *numberLabel;
}
@end

@implementation OrderInfoGoodsListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 4;
        CGFloat imgWidth = 82;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (OrderInfoGoodsListCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        CGFloat yOffset = 20;
        xOffset += imgWidth+8;
        CGFloat nameLabelWidth = 200;
        CGFloat namelabelHieght = 38;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, namelabelHieght);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        CGFloat comLabelHeight = namelabelHieght/2;
        yOffset += namelabelHieght+5;
        stockLabel = [[WXUILabel alloc] init];
        stockLabel.frame = CGRectMake(xOffset, yOffset, 150, comLabelHeight);
        [stockLabel setBackgroundColor:[UIColor clearColor]];
        [stockLabel setTextAlignment:NSTextAlignmentLeft];
        [stockLabel setFont:WXFont(10.0)];
        [stockLabel setTextColor:WXColorWithInteger(0xc6c6c6)];
        [self.contentView addSubview:stockLabel];
        
        yOffset += comLabelHeight+5;
        priceLabel = [[WXUILabel alloc] init];
        priceLabel.frame = CGRectMake(xOffset, yOffset, 150, comLabelHeight);
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextAlignment:NSTextAlignmentLeft];
        [priceLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [priceLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:priceLabel];
        
        numberLabel = [[WXUILabel alloc] init];
        numberLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-10-50, yOffset, 50, comLabelHeight);
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        [numberLabel setTextAlignment:NSTextAlignmentRight];
        [numberLabel setFont:WXFont(14.0)];
        [numberLabel setTextColor:WXColorWithInteger(0x434343)];
        [self.contentView addSubview:numberLabel];
    }
    return self;
}

-(void)load{
    AllOrderListEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.goodsImg];
    [imgView load];
    
    [nameLabel setText:entity.goodsName];
    [stockLabel setText:entity.stockName];
    [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",entity.stockPrice]];
    [numberLabel setText:[NSString stringWithFormat:@"X%ld",(long)entity.buyNumber]];
}

@end
