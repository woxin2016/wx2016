//
//  GoodsInfoStockCell.m
//  RKWXT
//
//  Created by app on 16/3/18.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "GoodsInfoStockCell.h"
#import "WXRemotionImgBtn.h"
#import "GoodsInfoEntity.h"
#import "VirtualGoodsInfoEntity.h"

#define Size self.frame.szie

@interface GoodsInfoStockCell ()
{
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *priceLabel;
    WXUILabel *stockLabel;
}
@end

@implementation GoodsInfoStockCell

+ (instancetype)GoodsInfoStockCellWithTableView:(UITableView*)tableView{
    static NSString *identifier = @"GoodsInfoStockCell";
    GoodsInfoStockCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[GoodsInfoStockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat offsetX = 10;
        CGFloat offsetY = 10;
        CGFloat imgWidth = 60;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(offsetX,offsetY, 60, 60)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        
        CGFloat nameW = self.frame.size.width - offsetX * 3 - imgWidth;
        CGFloat nameH = 20;
        offsetY += 2;
        offsetX += (imgWidth + 10);
        nameLabel = [[WXUILabel alloc]initWithFrame:CGRectMake(offsetX, offsetY, nameW, nameH)];
        [nameLabel setFont:[UIFont systemFontOfSize:15]];
        nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:nameLabel];
        
        offsetY += nameH + 3;
        CGFloat priceH = 15;
        priceLabel = [[WXUILabel alloc]initWithFrame:CGRectMake(offsetX, offsetY, nameW, priceH)];
        priceLabel.textColor = [UIColor colorWithHexString:@"#f74f35"];
        priceLabel.font = WXFont(14.0);
        [self.contentView addSubview:priceLabel];
        
        offsetY += priceH + 3;
        CGFloat stockH = 15;
        stockLabel = [[WXUILabel alloc]initWithFrame:CGRectMake(offsetX, offsetY, nameW, stockH)];
        stockLabel.textColor = [UIColor colorWithHexString:@"#bababa"];
        stockLabel.font = WXFont(14.0);
        [self.contentView addSubview:stockLabel];
        
    }
    return self;
}

-(void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
}

- (void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f",entity.stockPrice];
    nameLabel.text = entity.stockName;
    stockLabel.text = [NSString stringWithFormat:@"库存:%d",entity.stockNum];
    
    [imgView setCpxViewInfo:self.imgUrl];
    [imgView load];
}

- (void)setPrice{
    VirtualGoodsInfoEntity *entity = self.cellInfo;
    priceLabel.text = [NSString stringWithFormat:@"所需云票:%.d",entity.xnb];
}

- (void)setPriceAddXnb{
    VirtualGoodsInfoEntity *entity = self.cellInfo;
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f + %.d云票",entity.stockPrice,entity.xnb];
}



-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

@end
