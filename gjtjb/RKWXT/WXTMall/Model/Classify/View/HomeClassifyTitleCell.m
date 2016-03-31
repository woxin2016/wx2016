//
//  HomeClassifyTitleCell.m
//  RKWXT
//
//  Created by SHB on 16/3/31.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomeClassifyTitleCell.h"
#import "NewHomePageCommonDef.h"

@implementation HomeClassifyTitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat nameWidth = 80;
        CGFloat nameHeight = 20;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (T_HomePageTextSectionHeight-nameHeight)/2, nameWidth, nameHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"分类"];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0xf74f35)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        WXUIButton *moreBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-nameWidth, (T_HomePageTextSectionHeight-nameHeight)/2, nameWidth, nameHeight);
        [moreBtn setBackgroundColor:[UIColor clearColor]];
        [moreBtn setTitle:@"|更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:WXColorWithInteger(0x707070) forState:UIControlStateNormal];
        [moreBtn.titleLabel setFont:WXFont(12.0)];
        [moreBtn addTarget:self action:@selector(moreBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:moreBtn];
    }
    return self;
}

-(void)load{
    
}

-(void)moreBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(homeClassifyMoreBtnClicked)]){
        [_delegate homeClassifyMoreBtnClicked];
    }
}

@end
