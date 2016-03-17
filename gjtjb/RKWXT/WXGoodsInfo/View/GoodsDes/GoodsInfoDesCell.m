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
    UIView *didView;
}
@end

@implementation GoodsInfoDesCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12;
        CGFloat yOffset = 12;
        CGFloat desWidth = IPHONE_SCREEN_WIDTH-2*xOffset;
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
//        shopPrice.frame = CGRectMake(IPHONE_SCREEN_WIDTH/2-20-priceLabelWidth, yOffset, priceLabelWidth, priceLabelHeight);
        shopPrice.frame = CGRectMake(xOffset, yOffset, priceLabelWidth, priceLabelHeight);
        [shopPrice setBackgroundColor:[UIColor clearColor]];
        [shopPrice setTextAlignment:NSTextAlignmentLeft];
        [shopPrice setTextColor:WXColorWithInteger(AllBaseColor)];
        [shopPrice setFont:WXFont(17.0)];
        [self.contentView addSubview:shopPrice];
        
        yOffset += priceLabelHeight + 3;
        marketPrice = [[WXUILabel alloc] init];
//        marketPrice.frame = CGRectMake(IPHONE_SCREEN_WIDTH/2+20, yOffset, priceLabelWidth, priceLabelHeight);
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
        
//        yOffset += 20;
//        didView = [[UIView alloc]initWithFrame:CGRectMake(0, yOffset, self.frame.size.width, 0.5)];
//        didView.backgroundColor = [UIColor grayColor];
//        didView.alpha = 0.8;
//        [self.contentView addSubview:didView];
        
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
        
    }
    return self;
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    [desLabel setText:entity.goodsName];
    
    NSString *marketPriceString = [NSString stringWithFormat:@"￥%.2f",entity.marketPrice];  //￥金额符号
    [shopPrice setText:[NSString stringWithFormat:@"￥%.2f",entity.shopPrice]];
    [marketPrice setText:marketPriceString];
    
    CGRect rect = lineLabel.frame;
    rect.size.width = [NSString widthForString:marketPriceString fontSize:14.0 andHeight:20];
    [lineLabel setFrame:rect];
    
    
//    if(_userCut){
//        [usercutBtn setHidden:NO];
//    }
//    if(entity.postage == Goods_Postage_None){
//        [carriageBtn setHidden:NO];
//    }
//    if(entity.postage == Goods_Postage_None && !_userCut){
//        [carriageBtn setHidden:NO];
//        CGRect rect = carriageBtn.frame;
//        rect.origin.x = 12;
//        [carriageBtn setFrame:rect];
//    }
//    if(entity.postage == Goods_Postage_Have && !_userCut){
//        [carriageBtn setHidden:YES];
//        [usercutBtn setHidden:YES];
//    }
    [self refreshCentent];
  
}

- (void)refreshCentent{
    
    // 提成  包邮  使用红包
    if (self.stockEntity.redPacket) {   // 可以使用红包
        [redPacketBtn setHidden:NO];
    }else{
        [redPacketBtn setHidden:YES];
    }
    
    if (self.stockEntity.userCut) {     //有提成
        [usercutBtn setHidden:NO];
    }else{
        [usercutBtn setHidden:YES];
        carriageBtn.frame = usercutBtn.frame;
        redPacketBtn.frame = carriageBtn.frame;
    }
    
    GoodsInfoEntity *entity = self.cellInfo;
    if(entity.postage == Goods_Postage_None){  //包邮
        [carriageBtn setHidden:NO];
    }else{
        [carriageBtn setHidden:YES];
        redPacketBtn.frame = carriageBtn.frame;
    }
    
    if (!self.stockEntity.userCut && !self.stockEntity.redPacket && entity.postage == Goods_Collection_None) {
        topView.hidden = YES;
        didView.hidden = YES;
    }else{
        topView.hidden = NO;
        didView.hidden = NO;
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

@end
