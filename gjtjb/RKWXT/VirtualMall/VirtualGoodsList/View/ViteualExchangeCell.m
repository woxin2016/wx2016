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
    UIView *markDidView;
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
        CGFloat yOffset = 7;
        CGFloat imageH = 120;
        CGFloat imageW = imageH;
        _imgView = [[WXRemotionImgBtn alloc]initWithFrame:CGRectMake(xOffset, yOffset, imageW, imageH)];
        [self.contentView addSubview:_imgView];
        
        xOffset += imageW + 5;
        yOffset += 2;
        CGFloat nameLH = 35;
        CGFloat nameLW = (self.width - 30) - imageW;
        nameL = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, nameLW, nameLH)];
        nameL.font = WXFont(14.0);
        nameL.textAlignment = NSTextAlignmentLeft;
        nameL.numberOfLines = 2;
        nameL.textColor = [UIColor blackColor];
        [self.contentView addSubview:nameL];
        
        yOffset += nameLH + 8;
        CGFloat pricelH = 15;
        priceL = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, nameLW, pricelH)];
        priceL.font = WXFont(14.0);
        priceL.textAlignment = NSTextAlignmentLeft;
        priceL.textColor = [UIColor redColor];
        [self.contentView addSubview:priceL];
        
        yOffset += pricelH + 10;
        CGFloat virlH = 15;
        CGFloat virW = 65;
        UILabel *virLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, virW, virlH)];
        virLabel.font = WXFont(13.0);
        virLabel.textAlignment = NSTextAlignmentLeft;
        virLabel.textColor = [UIColor redColor];
        virLabel.text = @"官方价格:";
        [self.contentView addSubview:virLabel];
        
        virPrice = [[UILabel alloc]initWithFrame:CGRectMake(virLabel.right, yOffset, nameLW - virW, virlH)];
        virPrice.font = WXFont(13.0);
        virPrice.textAlignment = NSTextAlignmentLeft;
        virPrice.textColor = [UIColor redColor];
        [self.contentView addSubview:virPrice];
        
        markDidView = [[UIView alloc]init];
        markDidView.backgroundColor = [UIColor redColor];
        [virPrice addSubview:markDidView];
        
        yOffset += virlH + 10;
        CGFloat labelH = 12;
        CGFloat labelW = 80;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, labelW, labelH)];
        label.font = WXFont(12.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor grayColor];
        label.text = @"平台邮寄兑换";
        [self.contentView addSubview:label];
        
        CGFloat moneyLX = label.right;
        CGFloat moneyLW = self.width - label.right - 10;
        moneyL = [[UILabel alloc]initWithFrame:CGRectMake(moneyLX, yOffset, moneyLW, labelH)];
        moneyL.font = WXFont(12.0);
        moneyL.textAlignment = NSTextAlignmentLeft;
        moneyL.textColor = [UIColor grayColor];
        [self.contentView addSubview:moneyL];
        
        UIView *didView = [[UIView alloc]initWithFrame:CGRectMake(xOffset, [ViteualExchangeCell cellHeightOfInfo:nil] - 0.5 , self.width - xOffset, 0.5)];
        didView.backgroundColor = WXColorWithInteger(0xd6d6d6);
        [self.contentView addSubview:didView];
    }
    return self;
}


- (void)load{
    ViteualGoodsEntity *entity = self.cellInfo;
    
    [_imgView setCpxViewInfo:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.goodsIcon]];
    [_imgView setButtonEnable:NO];
    [_imgView load];
    
    nameL.text = entity.goodsName;
    priceL.text = [NSString stringWithFormat:@"价格:￥%.2f + %d云票",entity.goodsPrice,entity.xnb];
    virPrice.text = [NSString stringWithFormat:@"￥%.2f",entity.marPrice];
    markDidView.frame = CGRectMake(0, virPrice.height / 2 - 0.5 , [NSString sizeWithString:virPrice.text font:virPrice.font].width, 0.5);
    
    NSString *backStr = [NSString stringWithFormat:@"返现金额:￥%.2f",entity.backMoney];
    moneyL.text = backStr;
    CGFloat Width = [NSString sizeWithString:backStr font:moneyL.font].width;
    moneyL.X = self.width - Width - 10;
}

+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 140;
}


@end
