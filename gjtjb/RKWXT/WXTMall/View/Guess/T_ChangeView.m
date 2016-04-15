//
//  T_ChangeView.m
//  RKWXT
//
//  Created by app on 16/3/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "T_ChangeView.h"
#import "NewHomePageCommonDef.h"
#import "WXRemotionImgBtn.h"
#import "HomePageSurpEntity.h"
#import "HomeNewGuessInfoCell.h"

#define xGap 7

@interface T_ChangeView(){
    WXUIButton*bgBtn;
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *_newPriceLabel;
    WXUILabel *likeNumLabel;
    WXUILabel *hotNumLabel;
    WXUILabel *hotLeftLabel;
}
@end

@implementation T_ChangeView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:WXColorWithInteger(0xeeeeee)];

        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-3*xGap)/2;
        CGFloat bgHeight = T_HomePageGuessInfoHeight-7;
        bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(xGap, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(changeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat yOffset = 0;
        CGFloat xOffset = 7;
        CGFloat imgWidth = bgWidth;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [bgBtn addSubview:_imgView];
        
        yOffset += imgHeight+3;
        CGFloat nameLabelHeight = 30;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, imgWidth-xOffset, nameLabelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x5c615d)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_nameLabel setNumberOfLines:2];
        [bgBtn addSubview:_nameLabel];
        
        yOffset += nameLabelHeight;
        xOffset = 2;
        _newPriceLabel = [[WXUILabel alloc] init];
        _newPriceLabel.frame = CGRectMake(xOffset, yOffset, imgWidth/2, nameLabelHeight/2);
        [_newPriceLabel setBackgroundColor:[UIColor clearColor]];
        [_newPriceLabel setTextAlignment:NSTextAlignmentLeft];
        [_newPriceLabel setTextColor:WXColorWithInteger(0xf74f35)];
        [_newPriceLabel setFont:[UIFont systemFontOfSize:11.0]];
        [bgBtn addSubview:_newPriceLabel];
        
        xOffset = 5;
        yOffset += nameLabelHeight / 2 + 2;
        UIImage *likeImg = [UIImage imageNamed:@"UserLikeNewImg.png"];
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, yOffset+(nameLabelHeight/2-likeImg.size.height)/2, likeImg.size.width, likeImg.size.height);
        [imgView setImage:likeImg];
        [bgBtn addSubview:imgView];
        
        xOffset += likeImg.size.width+5;
        CGFloat numberWidth = 20;
        likeNumLabel = [[WXUILabel alloc] init];
        likeNumLabel.frame = CGRectMake(xOffset, yOffset, numberWidth, nameLabelHeight/2);
        [likeNumLabel setBackgroundColor:[UIColor clearColor]];
        [likeNumLabel setTextAlignment:NSTextAlignmentLeft];
        [likeNumLabel setTextColor:WXColorWithInteger(0x707070)];
        [likeNumLabel setFont:WXFont(10.0)];
        [bgBtn addSubview:likeNumLabel];
        
        xOffset = bgWidth / 2;
        CGFloat nameWidth = 20;
        hotLeftLabel = [[WXUILabel alloc] init];
        hotLeftLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameLabelHeight/2);
        [hotLeftLabel setBackgroundColor:[UIColor clearColor]];
        [hotLeftLabel setTextAlignment:NSTextAlignmentLeft];
        [hotLeftLabel setTextColor:WXColorWithInteger(0x707070)];
        [hotLeftLabel setFont:WXFont(10.0)];
        [hotLeftLabel setText:@"热度"];
        [bgBtn addSubview:hotLeftLabel];
        
        xOffset += nameWidth+2;
        hotNumLabel = [[WXUILabel alloc] init];
        hotNumLabel.frame = CGRectMake(xOffset, yOffset, numberWidth, nameLabelHeight/2);
        [hotNumLabel setBackgroundColor:[UIColor clearColor]];
        [hotNumLabel setTextAlignment:NSTextAlignmentLeft];
        [hotNumLabel setTextColor:WXColorWithInteger(0x707070)];
        [hotNumLabel setFont:WXFont(10.0)];
        [bgBtn addSubview:hotNumLabel];
    }
    return self;
}

-(void)changeBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[HomeNewGuessInfoCell class]]);
    if(superView && [superView isKindOfClass:[HomeNewGuessInfoCell class]]){
        HomeNewGuessInfoCell *cell = (HomeNewGuessInfoCell*)superView;
        id<HomeNewGuessInfoCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(changeCellClicked:)]){
            [delegate changeCellClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    HomePageSurpEntity *entity = self.cpxViewInfo;
    [_imgView setCpxViewInfo:entity.home_img];
    [_imgView load];
    NSString *shopPrice = [NSString stringWithFormat:@"￥%.2f",entity.shop_price];
    [_newPriceLabel setText:shopPrice];
    [_nameLabel setText:entity.goods_name];
    [likeNumLabel setText:[NSString stringWithFormat:@"%ld",(long)entity.likeNum]];
  
    NSString *hotStr = [NSString stringWithFormat:@"%ld",(long)entity.hotNum];
    CGFloat xOffset = ((IPHONE_SCREEN_WIDTH-3*xGap)/2) - [NSString sizeWithString:hotStr font:hotLeftLabel.font].width - hotLeftLabel.width - 10;
    hotLeftLabel.X = xOffset;
    [hotNumLabel setText:hotStr];
    hotNumLabel.X = hotLeftLabel.right + 3;
    
    if(entity.index%2==0){
        CGRect rect = bgBtn.frame;
        rect.origin.x = 3;
        [bgBtn setFrame:rect];
    }
}



@end