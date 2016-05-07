//
//  VirtualOrderGoodsCell.m
//  RKWXT
//
//  Created by app on 16/4/12.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualOrderGoodsCell.h"
#import "WXRemotionImgBtn.h"
#import "virtualOrderListEntity.h"

@interface VirtualOrderGoodsCell ()
{
    WXRemotionImgBtn *_imgView;
    UILabel *_nameLabel;
    UILabel *_stockName;
    UILabel *_priceLabel;
    UILabel *_buyNumber;
}
@end

@implementation VirtualOrderGoodsCell

+ (instancetype)VirtualOrderGoodsCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualOrderGoodsCell";
    VirtualOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualOrderGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat xOffset = 12;
        CGFloat imgWidth = 63;
        CGFloat imgHeight = imgWidth;
        CGFloat yOffset =  ([VirtualOrderGoodsCell cellHeightOfInfo:nil]-imgHeight)/2;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset,yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+10;
        yOffset += 2;
        CGFloat nameWidth = self.width - xOffset - 10;
        CGFloat nameHeight = 35;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setNumberOfLines:2];
        [_nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_nameLabel];
        
        yOffset += nameHeight + 2;
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
        
        yOffset += stockH + 3;
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
    virtualOrderListEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:entity.goods_img];
    [_imgView load];
    
    [_nameLabel setText:entity.goods_name];
    _stockName.text = entity.stockName;
    int price =  entity.xnb;
    [_priceLabel setText:[NSString stringWithFormat:@"所需云票%d",price]];
    
    _buyNumber.text = [NSString stringWithFormat:@"X 1"];
}


+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 95;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

@end
