//
//  ViteualStoreCell.m
//  RKWXT
//
//  Created by app on 16/4/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ViteualStoreCell.h"
#import "WXRemotionImgBtn.h"
#import "ViteualGoodsEntity.h"

@interface ViteualStoreCell ()
{
    WXRemotionImgBtn *_imgView;
    UILabel *nameL;
    UILabel *priceL;
    UILabel *markPL;
    UILabel *moneyL;
    UIView *markDidView;
}
@end

@implementation ViteualStoreCell

+ (instancetype)viteualStoreCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"ViteualStoreCell";
    ViteualStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ViteualStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        nameL.numberOfLines = 2;
        nameL.textAlignment = NSTextAlignmentLeft;
        nameL.textColor = [UIColor blackColor];
        [self.contentView addSubview:nameL];
        
        yOffset += nameLH + 8;
        CGFloat pricelH = 15;
        priceL = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, nameLW, pricelH)];
        priceL.font = WXFont(14.0);
        priceL.textAlignment = NSTextAlignmentLeft;
        priceL.textColor = [UIColor redColor];
        [self.contentView addSubview:priceL];
        
        
        yOffset += pricelH +10;
        CGFloat markH = 15;
        CGFloat maLW = 50;
        UILabel *maLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, maLW, markH)];
        maLabel.font = WXFont(13.0);
        maLabel.textAlignment = NSTextAlignmentLeft;
        maLabel.textColor = [UIColor redColor];
        maLabel.text = @"市场价:";
        [self.contentView addSubview:maLabel];
        
        markPL = [[UILabel alloc]initWithFrame:CGRectMake(maLabel.right, yOffset, nameLW - maLW, markH)];
        markPL.font = WXFont(13.0);
        markPL.textAlignment = NSTextAlignmentLeft;
        markPL.textColor = [UIColor redColor];
        [self.contentView addSubview:markPL];
        
        markDidView = [[UIView alloc]init];
        markDidView.backgroundColor = [UIColor redColor];
        [markPL addSubview:markDidView];
        
        yOffset += markH + 10;
        CGFloat labelH = 12;
        CGFloat labelW = 80;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, labelW, labelH)];
        label.font = WXFont(12.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor grayColor];
        label.text = @"平台邮寄兑换";
        [self.contentView addSubview:label];
        
        CGFloat moneyLW = self.width - label.right - 10;
        moneyL = [[UILabel alloc]initWithFrame:CGRectMake(label.right, yOffset, moneyLW, labelH)];
        moneyL.font = WXFont(12.0);
        moneyL.textAlignment = NSTextAlignmentLeft;
        moneyL.textColor = [UIColor grayColor];
        [self.contentView addSubview:moneyL];
        
        UIView *didView = [[UIView alloc]initWithFrame:CGRectMake(xOffset, [ViteualStoreCell cellHeightOfInfo:nil] - 0.5 , self.width - xOffset, 0.5)];
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
    priceL.text = [NSString stringWithFormat:@"所需云票:%d",entity.xnb];
    
    markPL.text = [NSString stringWithFormat:@"￥%.2f",entity.marPrice];
    markDidView.frame = CGRectMake(0, markPL.height / 2 - 0.5 , [NSString sizeWithString:markPL.text font:markPL.font].width, 0.5);
  
    NSString *backStr = [NSString stringWithFormat:@"返现金额:￥%.2f",entity.backMoney];
    moneyL.text = backStr;
    
    CGFloat Width = [NSString sizeWithString:backStr font:moneyL.font].width;
    moneyL.X = self.width - Width - 10;
}

+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 139;
}

@end
