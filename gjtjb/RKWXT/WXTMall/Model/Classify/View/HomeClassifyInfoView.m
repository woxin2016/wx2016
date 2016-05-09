//
//  HomeClassifyInfoView.m
//  RKWXT
//
//  Created by SHB on 16/4/1.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomeClassifyInfoView.h"
#import "NewHomePageCommonDef.h"
#import "WXRemotionImgBtn.h"
#import "HomeClassifyInfoCell.h"
#import "HomePageClassifyEntity.h"

@interface HomeClassifyInfoView(){
    WXUIButton *bgBtn;
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
}
@end

@implementation HomeClassifyInfoView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = IPHONE_SCREEN_WIDTH/ClassifyShow;
        CGFloat bgHeight = T_HomePageClassifyInfoHeight;
        bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:WXColorWithInteger(0xffffff)];
        [bgBtn addTarget:self action:@selector(classifyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat yOffset = 10;
        CGFloat imgWidth = 70;
        CGFloat imgHeight = 60;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake((bgWidth-imgWidth)/2, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [_imgView setBackgroundColor:[UIColor redColor]];
        [bgBtn addSubview:_imgView];
        
        yOffset += imgHeight;
        CGFloat nameLabelHeight = 15;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake((bgWidth-imgWidth)/2, yOffset, imgWidth, nameLabelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setTextColor:WXColorWithInteger(0x707070)];
        [_nameLabel setFont:[UIFont systemFontOfSize:11.0]];
        [bgBtn addSubview:_nameLabel];
    }
    return self;
}

-(void)classifyBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[HomeClassifyInfoCell class]]);
    if(superView && [superView isKindOfClass:[HomeClassifyInfoCell class]]){
        HomeClassifyInfoCell *cell = (HomeClassifyInfoCell*)superView;
        id<HomeClassifyInfoCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(homeClassifyInfoBtnClicked:)]){
            [delegate homeClassifyInfoBtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    HomePageClassifyEntity *entity = self.cpxViewInfo;
    [_imgView setCpxViewInfo:entity.cat_img];
    [_imgView load];
    [_nameLabel setText:entity.cat_name];
}

@end