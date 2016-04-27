//
//  HomeLimitBuyCell.m
//  RKWXT
//
//  Created by SHB on 16/1/18.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomeLimitBuyCell.h"
#import "NewHomePageCommonDef.h"
#import "HomeLimitGoodsEntity.h"
#import "LImitGoodsEntity.h"
#import "LimitGoodsView.h"

#define kTimerInterval (5.0)
#define kOneCellShowNumber (5)
#define xGap (10)
@interface HomeLimitBuyCell ()<UIScrollViewDelegate>{
    UIScrollView *_browser;
    NSArray *classifyArr;
    NSInteger count;
    
    NSMutableArray *_merchantImgViewArray;
}
@end

@implementation HomeLimitBuyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setUserInteractionEnabled:YES];
        CGRect rect = [self bounds];
        rect.size.height = T_HomePageLimitBuyHeight;
        _browser = [[UIScrollView alloc] initWithFrame:rect];
        [_browser setDelegate:self];
        [_browser setShowsHorizontalScrollIndicator:NO];
        [_browser setShowsVerticalScrollIndicator:NO];
        _browser.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_browser];
    }
    return self;
}

-(void)setCellInfo:(id)cellInfo{
    [_browser.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    HomeLimitGoodsEntity *goodsEntity = cellInfo;
    CGRect rect = self.frame;
    rect.size.height = T_HomePageLimitBuyHeight;
    self.frame = rect;
    
    CGFloat xOffset = 10;
    CGFloat speace = 9.5;
    CGFloat width = self.frame.size.width / 3.5;
    CGFloat Height = self.frame.size.height;
    for(NSInteger i = 0; i < [goodsEntity.goodsArray count]; i++){
        
        CGFloat X =  xOffset + ((width + speace) * i);
        LImitGoodsEntity *entity = goodsEntity.goodsArray[i];
        
        LimitGoodsView *view = [[LimitGoodsView alloc]initWithFrame:CGRectMake(X, 0, width, Height)];
        view.entity = entity;
        [_browser addSubview:view];
        
//        CGFloat marH = 80;
        CGFloat Nmar = xOffset - (speace - 0.5) / 2;
        CGFloat maelX = i > 0 ? Nmar + ((width + speace) * i) : -100;
        UILabel *marLabel = [[UILabel alloc]initWithFrame:CGRectMake(maelX, 8, 0.5, view.frame.size.width)];
        marLabel.backgroundColor = [UIColor colorWithHexString:@"9b9b9b"];
        marLabel.alpha = 0.6;
        [_browser addSubview:marLabel];
       }
    [_browser setContentSize:CGSizeMake((xOffset + width ) * [goodsEntity.goodsArray count], T_HomePageLimitBuyHeight)];
}



-(void)buttonImageClicked:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(clickClassifyBtnAtIndex:)]){
        [_delegate clickClassifyBtnAtIndex:0];
    }
}

@end
