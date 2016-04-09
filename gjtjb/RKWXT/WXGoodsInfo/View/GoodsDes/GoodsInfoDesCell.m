//
//  GoodsInfoDesCell.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "GoodsInfoDesCell.h"
#import "GoodsInfoEntity.h"

@interface GoodsInfoDesCell(){
    WXUILabel *desLabel;
    WXUILabel *shopPrice;
    WXUILabel *marketPrice;
    WXUILabel *lineLabel;
    WXUIButton *usercutBtn;
    WXUIButton *carriageBtn;
    WXUIButton *redPacketBtn;
    UIView *topView;
    
    WXUILabel *line;
    WXUIButton *_attentionBtn;
    WXUILabel *_attentionLabel;
    BOOL _isAttection;
    CGRect redRect;
    CGRect cutRect;
    CGRect carRect;
}
@end

@implementation GoodsInfoDesCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
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
        [self.contentView addSubview:desLabel];
        
        yOffset += desHeight + 3;
        CGFloat priceLabelWidth = 120;
        CGFloat priceLabelHeight = 20;
        shopPrice = [[WXUILabel alloc] init];
        shopPrice.frame = CGRectMake(xOffset, yOffset, priceLabelWidth, priceLabelHeight);
        [shopPrice setBackgroundColor:[UIColor clearColor]];
        [shopPrice setTextAlignment:NSTextAlignmentLeft];
        [shopPrice setTextColor:WXColorWithInteger(AllBaseColor)];
        [shopPrice setFont:WXFont(17.0)];
        [self.contentView addSubview:shopPrice];
        
        yOffset += priceLabelHeight + 3;
        marketPrice = [[WXUILabel alloc] init];
        marketPrice.frame = CGRectMake(xOffset, yOffset, priceLabelWidth, priceLabelHeight);
        [marketPrice setBackgroundColor:[UIColor clearColor]];
        [marketPrice setTextAlignment:NSTextAlignmentLeft];
        [marketPrice setTextColor:WXColorWithInteger(0x9b9b9b)];
        [marketPrice setFont:WXFont(14.0)];
        [self.contentView addSubview:marketPrice];
        
        lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(0, priceLabelHeight/2, priceLabelWidth/2, 0.5);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [marketPrice addSubview:lineLabel];
        
        yOffset += priceLabelHeight + 3;
        topView = [[UIView alloc]initWithFrame:CGRectMake(0, yOffset, self.frame.size.width, 20)];
        topView.backgroundColor = WXColorWithInteger(0xd6d6d6);
        topView.alpha = 0.2;
        [self.contentView addSubview:topView];
        
        
        yOffset += 10 + 20;
        CGFloat btnWidth = 70;
        CGFloat btnHieght = 20;
        usercutBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        usercutBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHieght);
        [usercutBtn setBackgroundColor:[UIColor whiteColor]];
        [usercutBtn setBorderRadian:2.0 width:0.5 color:WXColorWithInteger(0xdbdbdb)];
        [usercutBtn setImage:[UIImage imageNamed:@"LMUserCutImg.png"] forState:UIControlStateNormal];
        [usercutBtn setTitle:@" 提成" forState:UIControlStateNormal];
        [usercutBtn.titleLabel setFont:WXFont(9.0)];
        [usercutBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
        [usercutBtn setHidden:YES];
        [usercutBtn addTarget:self action:@selector(userCutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:usercutBtn];
        cutRect = usercutBtn.frame;
        
        xOffset += btnWidth+10;
        carriageBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        carriageBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHieght);
        [carriageBtn setBackgroundColor:[UIColor whiteColor]];
        [carriageBtn setBorderRadian:0.5 width:0.5 color:WXColorWithInteger(0xdbdbdb)];
        [carriageBtn setImage:[UIImage imageNamed:@"LMCarriageImg.png"] forState:UIControlStateNormal];
        [carriageBtn setTitle:@" 包邮" forState:UIControlStateNormal];
        [carriageBtn.titleLabel setFont:WXFont(9.0)];
        [carriageBtn setHidden:YES];
        [carriageBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
        [carriageBtn addTarget:self action:@selector(carriageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:carriageBtn];
        carRect = carriageBtn.frame;
        
        xOffset += btnWidth+10;
        redPacketBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        redPacketBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHieght);
        [redPacketBtn setBackgroundColor:[UIColor whiteColor]];
        [redPacketBtn setBorderRadian:0.5 width:0.5 color:WXColorWithInteger(0xdbdbdb)];
        [redPacketBtn setImage:[UIImage imageNamed:@"LMResPackingImg.png"] forState:UIControlStateNormal];
        [redPacketBtn setTitle:@" 红包" forState:UIControlStateNormal];
        [redPacketBtn.titleLabel setFont:WXFont(9.0)];
        [redPacketBtn setHidden:YES];
        [redPacketBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
        [redPacketBtn addTarget:self action:@selector(redPacketBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:redPacketBtn];
        redRect = redPacketBtn.frame;
        
        
        xOffset = IPHONE_SCREEN_WIDTH-62;
        yOffset = 10;
        line = [[WXUILabel alloc] init];
        line.frame = CGRectMake(xOffset, yOffset, 0.5, GoodsInfoDesCellHeight-2*yOffset);
        [line setBackgroundColor:WXColorWithInteger(0xcacaca)];
        [self.contentView addSubview:line];
        
        CGFloat btnNewWidth = 27;
        CGFloat btnHeight = 25;
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionBtn.frame = CGRectMake(xOffset+(IPHONE_SCREEN_WIDTH-xOffset-btnNewWidth)/2, yOffset+(GoodsInfoDesCellHeight-yOffset-btnHeight-25)/2, btnNewWidth, btnHeight);
        [_attentionBtn setImage:[UIImage imageNamed:@"T_Attention@2x.png"] forState:UIControlStateNormal];
        [_attentionBtn addTarget:self action:@selector(payAttention:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_attentionBtn];
        
        _attentionLabel = [[WXUILabel alloc] init];
        _attentionLabel.frame = CGRectMake(_attentionBtn.frame.origin.x-(60-btnNewWidth)/2, _attentionBtn.frame.origin.y+_attentionBtn.frame.size.height, 60, 25);
        [_attentionLabel setBackgroundColor:[UIColor clearColor]];
        [_attentionLabel setTextAlignment:NSTextAlignmentCenter];
        [_attentionLabel setTextColor:WXColorWithInteger(0xcacaca)];
        [_attentionLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:_attentionLabel];
        
        
    }
    return self;
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    [desLabel setText:entity.goodsName];
    
    NSString *marketPriceString = [NSString stringWithFormat:@"￥%.2f",entity.marketPrice];  //￥金额符号
    [shopPrice setText:[NSString stringWithFormat:@"￥%.2f",entity.shopPrice]];
    [marketPrice setText:marketPriceString];
    
    CGRect rectl = lineLabel.frame;
    rectl.size.width = [NSString widthForString:marketPriceString fontSize:14.0 andHeight:20];
    [lineLabel setFrame:rectl];
    
    [self refreshCentent];
}

- (void)refreshCentent{
    
    GoodsInfoEntity *entity = self.cellInfo;
    if (self.stockEntity.userCut){ // 有提成
        [usercutBtn setHidden:NO];
        
        if (entity.postage == Goods_Postage_None) { //包邮
            [carriageBtn setHidden:NO];
            
            [self useRed];
            
        }else{
            [carriageBtn setHidden:YES];
            
            if (self.stockEntity.redPacket) { //红包
                [redPacketBtn setHidden:NO];
                redPacketBtn.frame = carRect;
            }
        }
        
    }else{ // 没有提成
        [usercutBtn setHidden:YES];
        
        if (entity.postage == Goods_Postage_None) { //包邮
            [carriageBtn setHidden:NO];
            carriageBtn.frame = cutRect;
            
            if (self.stockEntity.redPacket) { // 红包
                [redPacketBtn setHidden:NO];
                redPacketBtn.frame = carRect;
            }
            
        }else{ // 不包邮
            [carriageBtn setHidden:YES];
            
            if (self.stockEntity.redPacket) { //红包
                [redPacketBtn setHidden:NO];
                redPacketBtn.frame = cutRect;
            }
            
        }
    }

    
    if (!self.stockEntity.userCut && !self.stockEntity.redPacket && entity.postage == Goods_Postage_Have) {
        topView.hidden = YES;
    }else{
        topView.hidden = NO;
    }
}

- (void)useRed{
    if (self.stockEntity.redPacket) { //红包
        [redPacketBtn setHidden:NO];
    }else{
        [redPacketBtn setHidden:YES];
    }
}

-(void)userCutBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(goodsInfoDesCutBtnClicked)]){
        [_delegate goodsInfoDesCutBtnClicked];
    }
}

-(void)carriageBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(goodsInfoDesCarriageBtnClicked)]){
        [_delegate goodsInfoDesCarriageBtnClicked];
    }
}

- (void)redPacketBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(goodsInfoDesredPacketBtnClicked)]){
        [_delegate goodsInfoDesredPacketBtnClicked];
    }
}

-(void)setStockEntity:(GoodsInfoEntity *)stockEntity{
    _stockEntity = stockEntity;
}

- (void)payAttention:(WXUIButton*)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(goodsInfoDesAddlikeGoods:)]) {
        [_delegate goodsInfoDesAddlikeGoods:_isAttection];
    }
}

- (void)setLikeGoodsisAttection:(BOOL)attection{
    _isAttection = attection;
    if (attection) {
        [_attentionBtn setImage:[UIImage imageNamed:@"T_AttentionSel.png"] forState:UIControlStateNormal];
        [_attentionLabel setText:@"已收藏"];
    }else{
        [_attentionBtn setImage:[UIImage imageNamed:@"T_Attention.png"] forState:UIControlStateNormal];
        [_attentionLabel setText:@"未收藏"];
    }
}

- (void)limitGoodsInfoHidden{
    _attentionBtn.hidden = YES;
    _attentionLabel.hidden = YES;
    line.hidden = YES;
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

@end
