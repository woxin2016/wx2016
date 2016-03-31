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
}
@end

@implementation T_ChangeView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:WXColorWithInteger(0xeeeeee)];

        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-3*xGap)/2;
        CGFloat bgHeight = T_HomePageGuessInfoHeight-7;
        bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
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
        
        yOffset += imgHeight;
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
        
        xOffset += imgWidth/2;
        UIImage *likeImg = [UIImage imageNamed:@"UserLikeImg.png"];
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, yOffset+(nameLabelHeight/2-likeImg.size.height)/2, likeImg.size.width, likeImg.size.height);
        [imgView setImage:likeImg];
        [bgBtn addSubview:imgView];
        
        xOffset += likeImg.size.width;
        CGFloat numberWidth = 20;
        likeNumLabel = [[WXUILabel alloc] init];
        likeNumLabel.frame = CGRectMake(xOffset, yOffset, numberWidth, nameLabelHeight/2);
        [likeNumLabel setBackgroundColor:[UIColor clearColor]];
        [likeNumLabel setTextAlignment:NSTextAlignmentLeft];
        [likeNumLabel setTextColor:WXColorWithInteger(0x707070)];
        [likeNumLabel setFont:WXFont(10.0)];
        [bgBtn addSubview:likeNumLabel];
        
        xOffset += numberWidth;
        CGFloat nameWidth = 20;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameLabelHeight/2);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:WXColorWithInteger(0x707070)];
        [nameLabel setFont:WXFont(10.0)];
        [nameLabel setText:@"热度"];
        [bgBtn addSubview:nameLabel];
        
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
    [likeNumLabel setText:@"80"];
    [hotNumLabel setText:@"12"];
    
    if(entity.index%2==0){
        CGRect rect = bgBtn.frame;
        rect.origin.x = 4;
        [bgBtn setFrame:rect];
    }
}

// 计算高度 <先放着，不确定他这高度怎么计算的>
+ (CGFloat)sizeWithString:(NSString*)string font:(UIFont*)font maxW:(CGFloat)maxW{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = font;
    CGSize size = CGSizeMake(maxW, MAXFLOAT);
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height ;
    
}

@end