//
//  ViteualExchangeCell.m
//  RKWXT
//
//  Created by app on 16/4/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ViteualExchangeCell.h"
#import "WXRemotionImgBtn.h"
#import "ViteualGoodsEntity.h"

@interface ViteualExchangeCell ()
{
    WXRemotionImgBtn *_imgView;
    UILabel *nameL;
    UILabel *priceL;
    UILabel *virPrice;
    UILabel *moneyL;
}
@end

@implementation ViteualExchangeCell
+ (instancetype)viteualExchangeCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"ViteualExchangeCell";
    ViteualExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ViteualExchangeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = IPHONE_SCREEN_WIDTH;
        
        CGFloat xOffset = 10;
        CGFloat yOffset = 12;
        CGFloat imageH = 90;
        CGFloat imageW = imageH;
        _imgView = [[WXRemotionImgBtn alloc]initWithFrame:CGRectMake(xOffset, yOffset, imageW, imageH)];
        [self.contentView addSubview:_imgView];
        
        xOffset += imageW + 10;
        yOffset += 5;
        CGFloat nameLH = 25;
        CGFloat nameLW = (self.width - 30) - imageW;
        nameL = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, nameLW, nameLH)];
        nameL.font = WXFont(14.0);
        nameL.textAlignment = NSTextAlignmentLeft;
        nameL.textColor = [UIColor blackColor];
        [self.contentView addSubview:nameL];
        
        yOffset += nameLH + 5;
        CGFloat pricelH = 12;
        priceL = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, nameLW, pricelH)];
        priceL.font = WXFont(14.0);
        priceL.textAlignment = NSTextAlignmentLeft;
        priceL.textColor = [UIColor redColor];
        [self.contentView addSubview:priceL];
        
        yOffset += pricelH + 10;
        CGFloat virlH = 12;
        virPrice = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, nameLW, virlH)];
        virPrice.font = WXFont(14.0);
        virPrice.textAlignment = NSTextAlignmentLeft;
        virPrice.textColor = [UIColor redColor];
        [self.contentView addSubview:virPrice];
        
        
        yOffset += virlH + 8;
        CGFloat labelH = 12;
        CGFloat labelW = 80;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, labelW, labelH)];
        label.font = WXFont(13.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor grayColor];
        label.text = @"平台邮寄兑换";
        [self.contentView addSubview:label];
        
        CGFloat moneyLX = label.right;
        CGFloat moneyLW = self.width - label.right - 10;
        moneyL = [[UILabel alloc]initWithFrame:CGRectMake(moneyLX, yOffset, moneyLW, labelH)];
        moneyL.font = WXFont(13.0);
        moneyL.textAlignment = NSTextAlignmentLeft;
        moneyL.textColor = [UIColor grayColor];
        [self.contentView addSubview:moneyL];
        
    }
    return self;
}


- (void)load{
    ViteualGoodsEntity *entity = self.cellInfo;
    
    [_imgView setCpxViewInfo:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.goodsIcon]];
    [_imgView load];
    
    nameL.text = entity.goodsName;
    priceL.text = [NSString stringWithFormat:@"价格:￥%.2f + %.2f云票",entity.goodsPrice,entity.xnb];
    virPrice.text = [NSString stringWithFormat:@"官方价格:￥%.2f",entity.marPrice];
    
    NSString *backStr = [NSString stringWithFormat:@"返现金额:￥%.2f",entity.backMoney];
    moneyL.text = backStr;
    CGFloat Width = [NSString sizeWithString:backStr font:moneyL.font].width;
    moneyL.X = self.width - Width - 10;
}

+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 114;
}


@end
