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
        
        CGFloat btnWidth = 50;
        WXUIButton *moreBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-btnWidth, (T_HomePageTextSectionHeight-nameHeight)/2, btnWidth, nameHeight);
        [moreBtn setBackgroundColor:[UIColor clearColor]];
        [moreBtn setTitle:@"|更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:WXColorWithInteger(0x707070) forState:UIControlStateNormal];
        [moreBtn.titleLabel setFont:WXFont(12.0)];
        [moreBtn addTarget:self action:@selector(moreBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:moreBtn];
        
        UIView *didView = [[UIView alloc]initWithFrame:CGRectMake(0, T_HomePageTextSectionHeight - 0.5, self.width, 0.5)];
        didView.backgroundColor = WXColorWithInteger(0xcacaca);
        [self.contentView addSubview:didView];
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

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

@end
