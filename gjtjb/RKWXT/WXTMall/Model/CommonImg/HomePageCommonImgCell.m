//
//  HomePageCommonImgCell.m
//  RKWXT
//
//  Created by SHB on 16/3/31.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomePageCommonImgCell.h"
#import "HomePageTopEntity.h"
#import "WXRemotionImgBtn.h"
#import "NewHomePageCommonDef.h"

@interface HomePageCommonImgCell()<WXRemotionImgBtnDelegate>{
    WXRemotionImgBtn *imgView;
}

@end

@implementation HomePageCommonImgCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, T_HomePageCommonImgHeight)];
        [imgView setDelegate:self];
        [self.contentView addSubview:imgView];
    }
    return self;
}

-(void)load{
    HomePageTopEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.topImg];
    [imgView load];
}

-(void)buttonImageClicked:(id)sender{
    HomePageTopEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(homepageCommonImgCellClicked:)]){
        [_delegate homepageCommonImgCellClicked:entity];
    }
}

@end
