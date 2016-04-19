//
//  LimitGoodsView.m
//  RKWXT
//
//  Created by app on 16/3/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "LimitGoodsView.h"
#import "WXRemotionImgBtn.h"
#import "LImitGoodsEntity.h"
#import "NewHomePageCommonDef.h"

@interface LimitGoodsView ()
{
    WXRemotionImgBtn *_imgView;
    WXUILabel *_newPriceLabel;
    WXUILabel *_oldPriceLabel;
    WXUILabel *_nameLabel;
}
@end

@implementation LimitGoodsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
//        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-4*10)/3.5;
        CGFloat bgWidth = frame.size.width;
        CGFloat bgHeight = T_HomePageLimitBuyHeight;
        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(recommendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat yOffset = 8;
        CGFloat imgWidth = bgWidth;
        CGFloat imgHeight = imgWidth;
        CGFloat xOffset = (bgWidth-imgWidth)/2;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [bgBtn addSubview:_imgView];
        
      
        
        yOffset += imgHeight+7;
        CGFloat nameLabelHeight = 10;
        _newPriceLabel = [[WXUILabel alloc] init];
        _newPriceLabel.frame = CGRectMake(xOffset, yOffset, imgWidth, nameLabelHeight);
        [_newPriceLabel setBackgroundColor:[UIColor clearColor]];
        [_newPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [_newPriceLabel setTextColor:WXColorWithInteger(0x000000)];
        [_newPriceLabel setFont:[UIFont systemFontOfSize:12.0]];
        [bgBtn addSubview:_newPriceLabel];
        
        yOffset += nameLabelHeight+5;
        _oldPriceLabel = [[WXUILabel alloc] init];
        _oldPriceLabel.frame = CGRectMake(xOffset, yOffset, imgWidth, nameLabelHeight);
        [_oldPriceLabel setBackgroundColor:[UIColor clearColor]];
        [_oldPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [_oldPriceLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [_oldPriceLabel setFont:[UIFont systemFontOfSize:10.0]];
        [bgBtn addSubview:_oldPriceLabel];
        
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(xOffset + 4, yOffset+nameLabelHeight/2, imgWidth-2*10+8, 0.5);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [bgBtn addSubview:lineLabel];
        
        yOffset += nameLabelHeight+5;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, imgWidth, nameLabelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [bgBtn addSubview:_nameLabel];
        
        
        yOffset += nameLabelHeight + 5;
        CGFloat buyH = 25;
        UILabel *buyLabel = [[UILabel alloc]initWithFrame:CGRectMake(7.5, yOffset, bgWidth - 20, buyH)];
        [buyLabel setBorderRadian:buyH / 2 width:0.5 color:[UIColor colorWithHexString:@"f74f35"]];
        buyLabel.font = WXFont(14.0);
        buyLabel.textColor = [UIColor colorWithHexString:@"f74f35"];
        buyLabel.text = @"立即抢";
        buyLabel.textAlignment = NSTextAlignmentCenter;
        [bgBtn addSubview:buyLabel];
        
    }
    return self;
}

-(void)recommendBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[HomeLimitBuyCell class]]);
    if(superView && [superView isKindOfClass:[HomeLimitBuyCell class]]){
        HomeLimitBuyCell *cell = (HomeLimitBuyCell*)superView;
        id<HomeLimitBuyCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(homeRecommendCellbtnClicked:)]){
            [delegate homeLimitBuyCellbtnClicked:self.entity];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)setEntity:(LImitGoodsEntity *)entity{
    _entity = entity;
   
    [_imgView setCpxViewInfo:entity.goodsImg];
    [_imgView load];
    [_newPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[entity.goodsLowPic floatValue]]];
    [_oldPriceLabel setText:[NSString stringWithFormat:@"原价:￥%.2f",[entity.goodsPrice floatValue]]];
    [_nameLabel setText:entity.goodsName];
}

-(void)load{
    _entity = self.cpxViewInfo;
    
    [_imgView setCpxViewInfo:_entity.goodsImg];
    [_imgView load];
    [_newPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[_entity.goodsLowPic floatValue]]];
    [_oldPriceLabel setText:[NSString stringWithFormat:@"原价:￥%.2f",[_entity.goodsPrice floatValue]]];
    [_nameLabel setText:_entity.goodsName];
}



@end
