//
//  T_ChangeView.m
//  RKWXT
//
//  Created by app on 16/3/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "T_ChangeView.h"
#import "NewHomePageCommonDef.h"
//#import "T_ChangeCell.h"
#import "WXRemotionImgBtn.h"
#import "HomePageSurpEntity.h"
#import "HomeNewGuessInfoCell.h"

@interface T_ChangeView(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_moneylabel;
    WXUILabel *_descLabel;
}
@end

@implementation T_ChangeView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-3*xGap)/2;
        CGFloat bgHeight = T_HomePageGuessInfoHeight;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(changeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat xOffset = 7;
        CGFloat yOffset = xOffset;
        CGFloat imgHeight = bgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, bgWidth-2*xOffset, imgHeight-2*yOffset)];
        [_imgView setUserInteractionEnabled:NO];
        [self addSubview:_imgView];
        
        yOffset = imgHeight;
        CGFloat descHeight = bgHeight-yOffset - 12;
        _descLabel = [[WXUILabel alloc] init];
       _descLabel.frame = CGRectMake(8, yOffset, bgWidth-2*xGap, descHeight);
        [_descLabel setBackgroundColor:[UIColor clearColor]];
        [_descLabel setTextColor:WXColorWithInteger(0x323232)];
        [_descLabel setTextAlignment:NSTextAlignmentLeft];
        [_descLabel setNumberOfLines:2];
        [_descLabel setFont:[UIFont systemFontOfSize:10.0]];
        [bgBtn addSubview:_descLabel];
        
        
        yOffset += _descLabel.frame.size.height;
        CGFloat moneyWidth = 100;
        CGFloat moneyHeight = 12;
        _moneylabel = [[WXUILabel alloc] init];
        _moneylabel.frame = CGRectMake(8, yOffset, moneyWidth, moneyHeight);
        [_moneylabel setBackgroundColor:[UIColor clearColor]];
        [_moneylabel setTextAlignment:NSTextAlignmentLeft];
        [_moneylabel setTextColor:WXColorWithInteger(0xc00000)];
        [_moneylabel setFont:[UIFont systemFontOfSize:14.0]];
        [bgBtn addSubview:_moneylabel];
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
    [_moneylabel setText:shopPrice];
    [_descLabel setText:entity.goods_name];
}

// 计算高度 <先放着，不确定他这高度怎么计算的>
+ (CGFloat)sizeWithString:(NSString*)string font:(UIFont*)font maxW:(CGFloat)maxW{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = font;
    CGSize size = CGSizeMake(maxW, MAXFLOAT);
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height ;
    
}

@end